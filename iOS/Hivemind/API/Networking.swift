//
//  Networking.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class Networking {
        
    enum HttpMethod: String {
        case get    = "GET"
        case post   = "POST"
        case put    = "PUT"
        case delete = "DELETE"
        case patch  = "PATCH"
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Properties //
    
    private static let base_url = "https://hivemind-api-dev.herokuapp.com/"
    internal static let base_kraken = "https://api.kraken.com/0/public/OHLC"
        
    private static var tasks: [String : URLSessionDataTask] = [:]
    
    internal static var token: String?
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Foundational HTTP //
    
    private static func createTask(key: String, request: URLRequest, callback: @escaping JsonBlock) {
        if let existing_task = self.tasks[key] {
            existing_task.cancel()
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                callback(self.check(error: error), nil)
                return
            }
            
            var result: HardJSON = API.parse(data: data) ?? [:]
            if let absolute_url = request.url?.absoluteString {
                result["absolute_url"] = absolute_url
            }
            
            if let http_status = response as? HTTPURLResponse, http_status.statusCode != 200 {
                // All successful requests are assumed to return 200 -> Make sure the server fam knows this
                callback(self.check(response: http_status, json: result), result)
            } else {
                callback(.success, result)
            }
            
            self.tasks.removeValue(forKey: key)
        }
        
        task.resume()
        self.tasks[key] = task
    }
    
    
    private static func bootstrap(request: URLRequest, method: HttpMethod, auth: Bool) -> URLRequest? {
        var request = request
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if auth {
            if let token = self.token {
                request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
            } else {
                return nil
            }
        }
        return request
    }
    
    
    private static func update(key: String, method: HttpMethod, url: String, body: JSON, auth: Bool, callback: @escaping JsonBlock) {
        guard let url = URL(string: createFullURL(url: url)), var request = bootstrap(request: URLRequest(url: url), method: method, auth: auth) else {
            callback(.badauth, nil)
            return
        }
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                callback(.jsonreqerror, nil)
                return
            }
        }
        
        createTask(key: key, request: request, callback: callback)
    }
    
    
    static func createFullURL(url: String) -> String {
        let _url = Networking.base_url.removedLast(ifEquals: "/") + "/" + url.removedFirst(ifEquals: "/")
        if _url.contains("?") {
            return _url
        } else {
            return _url.removedLast(ifEquals: "/") + "/"
        }
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // HTTP Methods //
    
    internal static func post(key: String, url: String, body: JSON = nil, auth: Bool, callback: @escaping JsonBlock) {
        update(key: key, method: .post, url: url, body: body, auth: auth, callback: callback)
    }
    
    internal static func post(key: String, absoluteURL: String, body: JSON = nil, auth: Bool, callback: @escaping JsonBlock) {
        guard let url = URL(string: absoluteURL), var request = bootstrap(request: URLRequest(url: url), method: .post, auth: auth) else {
            callback(.badauth, nil)
            return
        }

        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                callback(.jsonreqerror, nil)
                return
            }
        }
        
        createTask(key: key, request: request, callback: callback)
    }
    
    
    internal static func put(key: String, url: String, body: JSON = nil, auth: Bool, callback: @escaping JsonBlock) {
        update(key: key, method: .put, url: url, body: body, auth: auth, callback: callback)
    }
    
    
    internal static func delete(key: String, url: String, body: JSON = nil, auth: Bool, callback: @escaping JsonBlock) {
        update(key: key, method: .delete, url: url, body: body, auth: auth, callback: callback)
    }
    
    
    internal static func patch(key: String, url: String, body: JSON = nil, auth: Bool, callback: @escaping JsonBlock) {
        update(key: key, method: .patch, url: url, body: body, auth: auth, callback: callback)
    }
    
    
    internal static func get(key: String, url: String, parameters: [String : String]? = nil, auth: Bool, callback: @escaping JsonBlock) {
        let url_string = createFullURL(url: url)
        
        var raw_request: URLRequest!
        if let param_str = parameters?.stringFromHttpParameters() {
            raw_request = URLRequest(url: URL(string: "\(url_string.removedLast(ifEquals: "/"))/?\(param_str)")!)
        } else {
            raw_request = URLRequest(url: URL(string: url_string)!)
        }
        
        guard let request = bootstrap(request: raw_request, method: .get, auth: auth) else {
            callback(.badauth, nil)
            return
        }
        
        createTask(key: key, request: request, callback: callback)
    }
    
    
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Parsing //
    
    private static func parse(data: Data) -> JSON {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] {
                return json
            }
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any] {
                return ["body" : json]
            }
        } catch {}
        return nil
    }
    
    
    private static func parseArrayToString(json: Any) -> String? {
        if let array = json as? [String], array.count == 1, let value = array[safe: 0] {
            return value
        }
        return nil
    }
    

    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\
    
    // Error Handling //
    
    // Error message comparison function to diagnose the proper error
    private static func compare(_ message: String, to errorMessage: String) -> Bool {
        return message.superSimpleContains(text: errorMessage)
    }
    
    
    private static func check(error: Error?) -> ActionStatus {
        guard let error = error as NSError? else {
            return .unrecognized
        }
        if error.code == NSURLErrorCancelled {
            return .cancelled
        }
        return .unrecognized
    }
    
    
    private static func check(response: HTTPURLResponse, json: JSON) -> ActionStatus {
        if response.statusCode == 404 {
            return .http404
        }
        
        guard let json = json else {
            if response.statusCode == 500 {
                return .http500
            }
            return .jsonreserror
        }
        
        for element in json {
            guard let message = (element.value as? String)?.simplified ?? (element.value as? [String])?[safe: 0] else {
                return .httpmsgerror
            }
            
            if compare(message, to: "This field may not be blank.") {
                return .missingfields
            }
            
            switch element.key {
            case "non_field_errors":
                if compare(message, to: "Unable to log in with provided credentials.") {
                    return .badcredentials
                }
            case "detail":
                if compare(message, to: "Invalid token.") {
                    return .badtoken
                } else if compare(message, to: "Authentication credentials were not provided") {
                    return .unauthorized
                } else if compare(message, to: "Method \"POST\" not allowed.") {
                    return .nopost
                }
            case "password":
                if compare(message, to: "This field is required.") {
                    return .missingpassword
                }
            case "old_password":
                if compare(message, to: "Invalid password") {
                    return .badpassword
                }
            default: break
            }
        }
        
        debugPrint("Unknown HTTP \(response.statusCode) error \n| JSON: \(json)")
        return .httpfail
    }
    
    
    
    
}
