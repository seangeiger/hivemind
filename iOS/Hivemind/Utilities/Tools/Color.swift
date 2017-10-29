//
//  Color.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class Color {
    
    static let white  = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    static let lite   = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
    static let gray   = UIColor(red: 196.0/255.0, green: 194.0/255.0, blue: 194.0/255.0, alpha: 1)
    static let grey   = UIColor(red: 196.0/255.0, green: 194.0/255.0, blue: 194.0/255.0, alpha: 1)
    static let slate  = UIColor(red:  35.0/255.0, green:  45.0/255.0, blue:  49.0/255.0, alpha: 1)
    static let black  = UIColor.black
    
    static let red    = UIColor(red: 191.0/255.0, green:  59.0/255.0, blue:  47.0/255.0, alpha: 1)
    static let salmon = UIColor(red: 235.0/255.0, green: 112.0/255.0, blue: 112.0/255.0, alpha: 1)
    static let orange = UIColor(red: 246.0/255.0, green:  81.0/255.0, blue:   0.0/255.0, alpha: 1)
    static let tangy  = UIColor(red: 235.0/255.0, green: 135.0/255.0, blue:  67.0/255.0, alpha: 1)
    static let yellow = UIColor(red: 241.0/255.0, green: 155.0/255.0, blue:  42.0/255.0, alpha: 1)
    static let banana = UIColor(red: 216.0/255.0, green: 175.0/255.0, blue:  47.0/255.0, alpha: 1)
    static let green  = UIColor(red: 144.0/255.0, green: 193.0/255.0, blue:  75.0/255.0, alpha: 1)
    static let neon   = UIColor(red: 137.0/255.0, green: 240.0/255.0, blue: 136.0/255.0, alpha: 1)
    static let forest = UIColor(red:  63.0/255.0, green:  96.0/255.0, blue:  10.0/255.0, alpha: 1)
    static let lime   = UIColor(red: 166.0/255.0, green: 253.0/255.0, blue: 112.0/255.0, alpha: 1)
    static let turq   = UIColor(red: 102.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    static let teal   = UIColor(red:  32.0/255.0, green: 157.0/255.0, blue: 133.0/255.0, alpha: 1)
    static let sky    = UIColor(red: 115.0/255.0, green: 236.0/255.0, blue: 252.0/255.0, alpha: 1)
    static let blue   = UIColor(red:   0.0/255.0, green: 162.0/255.0, blue: 183.0/255.0, alpha: 1)
    static let royal  = UIColor(red:  27.0/255.0, green:  69.0/255.0, blue: 115.0/255.0, alpha: 1)
    static let navy   = UIColor(red:  42.0/255.0, green:  61.0/255.0, blue:  77.0/255.0, alpha: 1)
    static let purple = UIColor(red:  74.0/255.0, green:  57.0/255.0, blue: 115.0/255.0, alpha: 1)
    static let pink   = UIColor(red: 213.0/255.0, green: 123.0/255.0, blue: 123.0/255.0, alpha: 1)
    
    static let bluefb = UIColor(red:  58.0/255.0, green:  89.0/255.0, blue: 152.0/255.0, alpha: 1)
    static let blueln = UIColor(red:  16.0/255.0, green: 102.0/255.0, blue: 153.0/255.0, alpha: 1)
    static let bluegg = UIColor(red:  66.0/255.0, green: 134.0/255.0, blue: 245.0/255.0, alpha: 1)
    
    // Hivemind Aesthetic
    
    static let green_light  = UIColor(red: 96.0/255.0,  green: 173.0/255.0, blue: 94.0/255.0,  alpha: 1)
    static let green_mid    = UIColor(red: 46.0/255.0,  green: 125.0/255.0, blue: 50.0/255.0,   alpha: 1)
    static let green_dark   = UIColor(red: 0.0/255.0,   green: 80.0/255.0,  blue: 5.0/255.0,    alpha: 1)
    static let red_light    = UIColor(red: 154.0/255.0, green: 59.0/255.0, blue: 56.0/255.0, alpha: 1)
    static let red_mid      = UIColor(red: 103.0/255.0, green: 8.0/255.0,   blue: 18.0/255.0,   alpha: 1)
    static let red_dark     = UIColor(red: 59.0/255.0,  green: 0.0/255.0,   blue: 0.0/255.0,    alpha: 1)
    
    static let purple_1 = UIColor(red: 148.0/255.0, green: 111.0/255.0, blue: 206.0/255.0, alpha: 1)
    static let purple_2 = UIColor(red: 101.0/255.0, green: 68.0/255.0,  blue: 150.0/255.0, alpha: 1)
    static let purple_3 = UIColor(red: 72.0/255.0,  green: 26.0/255.0,  blue: 109.0/255.0, alpha: 1)
    static let purple_4 = UIColor(red: 53.0/255.0,  green: 26.0/255.0,  blue: 109.0/255.0, alpha: 1)
    static let purple_5 = UIColor(red: 10.0/255.0,  green: 0.0/255.0,   blue: 65.0/255.0,   alpha: 1)
    
    static let charcoal = UIColor(red: 26.0/255.0, green: 26.0/255.0, blue: 26.0/255.0, alpha: 1)
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////////
    
    // Color Resolvers //
    
    static func resolve(_ preference: Preference.PreferenceType) -> UIColor {
        switch preference {
        case .bear:
            return Color.red_light
        case .bull:
            return Color.green_light
        case .neutral:
            return Color.purple_2
        }
    }
    
    
    
    
}










