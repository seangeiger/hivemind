//
//  API.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class API: Networking {
    
    // Model State //
    
    static var profile: Profile?
    static var preferences: [Preference] = []
    static var positions: [Position] = []
    static var assets: [Asset] = []
    
    static func startUpdates() {
        
    }
    
    static func pauseUpdates() {
        
    }
    
    
    // Auth //
    
    private static func set(token: String?) {
        API.token = token
        if SAVE_TOKEN {
            UserDefaultsManager.write(token: token)
        }
    }
    
    
    static func loadToken() -> Bool {
        if SAVE_TOKEN, let token = UserDefaultsManager.readToken() {
            API.token = token
            return true
        }
        return false
    }
    
    
    // Meat //
    
    static func login(username: String, password: String, callback: @escaping StatusBlock) {
        let body = ["username": username, "password": password]
        API.post(key: "login", url: "api-token-auth/", body: body, auth: false) { status, json in
            if status != .success {
                callback(status)
            } else if let key = json?["token"] as? String {
                set(token: key)
                API.getUser { status in
                    callback(.success)
                }
            } else {
                callback(.badauth)
            }
        }
    }
    
    static func logout() {
        set(token: nil)
        API.profile = nil
        API.preferences = []
        API.assets = []
        Utils.app_delegate.exit()
    }
    
    static func register(username: String, password: String, originalInvestment: Double, callback: @escaping StatusBlock) {        
        let body: HardJSON = ["username": username, "password": password, "profile": ["original_investment": originalInvestment]] as HardJSON
        
        API.post(key: "register", url: "user/", body: body, auth: false) { status, json in
            if status == .success {
                API.login(username: username, password: password) { status in
                    callback(status)
                }
            } else {
                callback(status)
            }
        }
    }
    
    static func getUser(callback: @escaping StatusBlock) {
        API.get(key: "user", url: "user/", auth: true) { status, json in
            if let profile_raw = json?["profile"] as? ObjJSON, let profile = Profile.parse(json: profile_raw) {
                API.profile = profile
                callback(.success)
            } else {
                callback(status)
            }
        }
    }
    
    static func getPreferences(callback: @escaping StatusBlock) {
        API.get(key: "getPreferences", url: "preferences/", auth: true) { status, json in
            if status != .success {
                callback(status)
            } else if let preferences_raw = json?["body"] as? [ObjJSON] {
                
                var preferences: [Preference] = []
                for element in preferences_raw {
                    if let preference = Preference.parse(json: element) {
                        preferences.append(preference)
                    }
                }
                
                API.preferences = preferences
                callback(.success)
            }
        }
    }
    
    static func getPositions(callback: @escaping StatusBlock) {
        API.get(key: "getPositions", url: "position/", auth: true) { status, json in
            if status != .success {
                callback(status)
            } else if let positions_raw = json?["body"] as? [ObjJSON] {
                
                var positions: [Position] = []
                for element in positions_raw {
                    if let position = Position.parse(json: element) {
                        positions.append(position)
                    }
                }
                
                API.positions = positions
                callback(.success)
            }
        }
    }
    
    static func updatePreference(preference: Preference.PreferenceType, asset: Asset, callback: @escaping StatusBlock) {
        let body = ["preference": preference.rawValue, "asset": asset.toJSON()] as HardJSON
        API.put(key: "putPreference", url: "preferences/", body: body, auth: true) { status, json in
            print(status)
            
            if status == .success {
                for i in 0..<API.preferences.count {
                    if let current = API.preferences[safe: i], current.asset.api_name == asset.api_name {
                        API.preferences[i].set(type: preference)
                        break
                    }
                }
            }
            callback(status)
        }
    }
    
    static func getAssets(callback: @escaping StatusBlock) {
        API.get(key: "getAssets", url: "assets/", auth: true) { status, json in
            if status != .success {
                callback(status)
            } else if let assets_raw = json?["body"] as? [ObjJSON] {
                
                var assets: [Asset] = []
                for element in assets_raw {
                    if let asset = Asset.parse(json: element) {
                        assets.append(asset)
                    }
                }
                
                API.assets = assets
                callback(.success)
            }
        }
    }
}





