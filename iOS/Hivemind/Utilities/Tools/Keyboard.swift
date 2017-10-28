//
//  Keyboard.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//


import Foundation

class Keyboard: NSObject {
    private(set) static var shared = Keyboard()
    private(set) var is_visible = false
    private var known_height: CGFloat = 0
    
    var height: CGFloat {
        get {
            return known_height < 1 ? 0.35 * Utils.screen.height : known_height
        }
    }
    
    func startListening(withHeight height: CGFloat? = nil) {
        if let height = height {
            self.known_height = height
        }
        NotificationCenter.default.addObserver(self, selector: #selector(willShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func willShow(notification: NSNotification) {
        is_visible = true
        let user_info = notification.userInfo! as NSDictionary
        let keyboard_frame: NSValue = user_info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        known_height = keyboard_frame.cgRectValue.height
    }
    
    @objc func willHide() {
        is_visible = false
    }
    
}

