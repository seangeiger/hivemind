//
//  API.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class API : Networking {
    
    // Model State
    //internal(set) static var user: User?

    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Polling //
    
    static func startUpdates() {
        
    }
    
    static func pauseUpdates() {

    }
    
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
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
            // Set model state with other stored data if required
            return true
        }
        return false
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    
    static func login(email: String, password: String, callback: @escaping StatusBlock) {
        API.post(key: "login", url: "login/", body: ["email" : email, "password": password], auth: false) { status, json in
            if status != .success {
                callback(status)
                
            } else if let key = json?["key"] as? String {
                set(token: key)
                
                // Verify with server (i.e. get profile), nullify with token if fail
                async(after: 1) {
                    callback(.success)
                }
                
            } else {
                callback(.badauth)
            }
        }
    }
    
    
    static func register(username: String, password: String, callback: @escaping StatusBlock) {
        // Turn unputs into hard JSON
        let body: HardJSON = ["username": username, "password": password] as HardJSON
        API.post(key: "register", url: "/registration/", body: body, auth: false) { status, json in
            callback(status)
        }
    }
    
    
    static func logout() {
        API.post(key: "logout", url: "logout/", auth: true) { status, json in
            set(token: nil)
            
            // Nullify model state
            Utils.app_delegate.exit()
        }
    }
    
    
    static func resetPassword(email: String, callback: @escaping StatusBlock) {
        API.post(key: "forgot_password", url: "/password/reset/", body: ["email": email], auth: false) { status, json in
            callback(status)
        }
    }
    
    
    static func changePassword(oldPassword: String, newPassword: String, callback: @escaping StatusBlock) {
        let body = ["old_password": oldPassword, "new_password1": newPassword, "new_password2": newPassword]
        API.post(key: "change_password", url: "/password/change", body: body, auth: true) { status, json in
            callback(status)
        }
    }
    
    
    static func changeEmail(newEmail: String, callback: @escaping StatusBlock) {
        API.patch(key: "change_email", url: "/user/", body: ["email": newEmail], auth: true) { status, json in
            callback(status)
        }
    }
    
    
}









