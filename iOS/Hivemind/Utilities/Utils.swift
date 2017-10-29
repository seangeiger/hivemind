//
//  Utils.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import UIKit
import CoreData

////////////////////////////////////////////////////////////////////////////////////////

let DEBUG_ON      = true

let SAVE_TOKEN    = true
let SAVE_KEYBOARD = true

let CACHE_IMAGES  = false
let IGNORE_LOGIN = false

////////////////////////////////////////////////////////////////////////////////////////

func + (left: CGFloat?, right: CGFloat?) -> CGFloat? {
    return left != nil ? right != nil ? left! + right! : left : right
}

func + (left: Int?, right: Int?) -> Int? {
    return left != nil ? right != nil ? left! + right! : left : right
}

func - (left: CGFloat?, right: CGFloat?) -> CGFloat? {
    return left != nil ? right != nil ? left! - right! : left : right
}

func - (left: Int?, right: Int?) -> Int? {
    return left != nil ? right != nil ? left! - right! : left : right
}

func + (left: String?, right: String?) -> String {
    return (left != nil ? right != nil ? left! + right! : left : right) ?? ""
}


func debugPrint(_ text: String) {
    if DEBUG_ON {
        print("[\(Date().midStyle)] > \(text)")
    }
}


func animate(function: @escaping VoidBlock) {
    UIView.animate(withDuration: 0.2) {
        function()
    }
}


func async(after seconds: Double, function: @escaping VoidBlock) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
        function()
    }
}


// An optional-string-coalescing operator (https://oleb.net/blog/2016/12/optionals-string-interpolation/)
infix operator ???: NilCoalescingPrecedence
public func ???<T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
    return optional.map { String(describing: $0) } ?? defaultValue()
}



class Utils {
    static var nav_height: CGFloat!
    
    static var top_height: CGFloat {
        return Utils.nav_height + Utils.status_height
    }
    
    static var status_height: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
    
    static var screen: CGSize {
        return UIScreen.main.bounds.size
    }
    
    static var bar_height: CGFloat {
        return Utils.top_height
    }
    
    static var app_delegate: AppDelegate {
        return (UIApplication.shared.delegate as! AppDelegate)
    }
    
    static func printAvailableFonts() {
        for family: String in UIFont.familyNames {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
    }
    
}












