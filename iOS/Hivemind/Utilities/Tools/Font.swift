//
//  Font.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

typealias FontAttributes = [NSAttributedStringKey : Any]

class Font {
    
    enum Name: String {
        case montserrat     = "Montserrat-Regular"
        case montserratBold = "Montserrat-Bold"
        case rawengulkSans  = "RawengulkSans"
    }
    
    enum SizeClass: Int {
        case _12
        case _13
        case _14
        case _15
        case _16
        case _17
        case _18
        case _20
        
        case _BIG
        case _BIGGER
        
        case count
    }
    
    static var device: Device = ._6_7
    enum Device: Int {
        case _4 = 0     // Ints used to index a SizeDict value tuple
        case _5
        case _6_7
        case _6_7_p
    }
    
    static let SizeDict: [SizeClass : [CGFloat]] = [
        ._12: [ 9, 10, 11, 12],
        ._13: [10, 11, 12, 13],
        ._14: [11, 12, 13, 14],
        ._15: [12, 13, 14, 15],
        ._16: [13, 14, 15, 16],
        ._17: [14, 15, 16, 17],
        ._18: [14, 15, 17, 18],
        ._20: [17, 18, 19, 20],
        
        ._BIG:    [21, 22, 23, 24],
        ._BIGGER: [23, 24, 25, 26]
    ]
    
    
    ////////////////////////////////////////////////////////////////////////////////////////
    
    static func determineDevice(fromSize size: CGSize) {
        if size.height < 500 {
            self.device = ._4
        } else if size.height < 600 {
            self.device = ._5
        } else if size.height < 700 {
            self.device = ._6_7
        } else {
            self.device = ._6_7_p
        }
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////
    
    static func makeAttrs(size: SizeClass, color: UIColor, bold: Bool = false, type: Font.Name = .montserrat) -> FontAttributes {
        if  let size = Font.SizeDict[size]?[safe: device.rawValue] {
            if type == .rawengulkSans, let font = UIFont(name: type.rawValue, size: size) {
                return [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: color]
            } else if let font = UIFont(name: bold ? Name.montserratBold.rawValue : Name.montserrat.rawValue, size: size) {
                return [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: color]
            }
        }
        debugPrint("Could not create font of size: \(size), color: \(color), bold: \(bold), type: \(type)")
        return [NSAttributedStringKey.foregroundColor: color]
    }
    
    
    static func make(text: String, size: SizeClass, color: UIColor, bold: Bool = false) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: Font.makeAttrs(size: size, color: color, bold: bold))
    }
    
    
    static func make(text: String, attributes: FontAttributes) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    
    static func parseHTML(text: String) -> NSAttributedString {
        let modified = "<span style=\"font-family: \(Name.montserrat.rawValue);\">\(text)</span>"
        return modified.utf8Data?.attributedString ?? text.utf8Data?.attributedString ?? Font.make(text: text, size: ._15, color: Color.black)
    }
    
    static func makeLegacyAttrs(size: SizeClass, color: UIColor, bold: Bool = false, type: Font.Name = .montserrat) -> [String : Any] {
        if  let size = Font.SizeDict[size]?[safe: device.rawValue] {
            if type == .rawengulkSans, let font = UIFont(name: type.rawValue, size: size) {
                return [NSAttributedStringKey.font.rawValue: font, NSAttributedStringKey.foregroundColor.rawValue: color]
            } else if let font = UIFont(name: bold ? Name.montserratBold.rawValue : Name.montserrat.rawValue, size: size) {
                return [NSAttributedStringKey.font.rawValue: font, NSAttributedStringKey.foregroundColor.rawValue: color]
            }
        }
        
        debugPrint("Could not create font of size: \(size), color: \(color), bold: \(bold)")
        return [NSAttributedStringKey.foregroundColor.rawValue: color]
    }
    
    
    
    
}
