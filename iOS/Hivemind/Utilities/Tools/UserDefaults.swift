//
//  UserDefaults.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    private enum Key: String {
        case token    = "token"
        case keyboard = "keyboard"
    }
    
    static func write(token: String?) {
        UserDefaults.standard.set(token, forKey: Key.token.rawValue)
        // Write other model state if required
    }
    
    static func readToken() -> String? {
        return UserDefaults.standard.string(forKey: Key.token.rawValue)
    }
    
    static func write(keyboardHeight: CGFloat?) {
        UserDefaults.standard.set(keyboardHeight, forKey: Key.keyboard.rawValue)
    }
    
    static func readKeyboardHeight() -> CGFloat {
        return CGFloat(UserDefaults.standard.float(forKey: Key.keyboard.rawValue))
    }
    
    
    
}

