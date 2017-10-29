//
//  User.swift
//  Hivemind
//
//  Created by Alex Dai on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//


import Foundation

class User {
    
    private(set) var username: String
    private(set) var profile: Profile
    
    init(username: String, profile: Profile) {
        self.username = username
        self.profile = profile
    }
    
    static func parse(json: ObjJSON) -> User? {
        guard
            let username    = json["username"] as? String,
            let profile_raw = json["profile"] as? ObjJSON,
            let profile     = Profile.parse(json: profile_raw)
        else {
            debugPrint("Could not load User serializer")
            return nil
        }
        
        return User(username: username, profile: profile)
    }
}
