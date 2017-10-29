//
//  String+.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

extension String {
    
    var length: Int { return self.characters.count }
    
    func compare(to string: String) -> Bool {
        return self.localizedCaseInsensitiveCompare(string) == .orderedAscending
    }
    
    func toBool() -> Bool {
        return self.simpleContains(text: "true") || self.simpleContains(text: "1")
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.height
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////
    
    func removedCharacters(in character_set: CharacterSet) -> String {
        return self.components(separatedBy: character_set).joined(separator: "")
    }
    
    
    func removedCharacters(in string: String) -> String {
        return removedCharacters(in: CharacterSet.init(charactersIn: string))
    }
    
    
    func keptOnlyCharacters(in character_set: CharacterSet) -> String {
        return self.components(separatedBy: character_set.inverted).joined(separator: "")
    }
    
    
    func keptOnlyCharacters(in string: String) -> String {
        return keptOnlyCharacters(in: CharacterSet.init(charactersIn: string))
    }

    func removedFirst(ifEquals character: String) -> String {
        if let first_character = self.first, String(first_character) == character {
            let start = self.index(self.startIndex, offsetBy: 1)
            return String(self[start...])
        }
        return self
    }
    
    func removedLast(ifEquals character: String) -> String {
        if let last_character = self.last, String(last_character) == character {
            let end = self.index(self.endIndex, offsetBy: -1)
            return String(self[..<end])
        }
        return self
    }
    
    func afterLast(_ character: String) -> String {
        return self.components(separatedBy: character).last ?? self
    }
    
    func successiveReplace(_ target: String = "%", with strings: [String]) -> String {
        var out_string = ""
        var index = 0
        
        for character in self.characters {
            if String(character) == target, let string = strings[safe: index] {
                index += 1
                out_string.append(string)
            } else {
                out_string.append(character)
            }
        }
        
        return out_string
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////
    
    var cleaned: String { return self.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) }
    
    
    var simplified: String { return self.lowercased().keptOnlyCharacters(in: .alphanumerics).trimmingCharacters(in: .whitespacesAndNewlines)}
    
    
    func simpleContains(text: String) -> Bool {
        return self.simplified.contains(text)
    }
    
    
    func superSimpleContains(text: String) -> Bool {
        return self.simplified.contains(text.simplified)
    }
    
    
    func superSimpleContains(_ contents: [String]) -> Bool {
        for content in contents {
            if self.superSimpleContains(text: content) {
                return true
            }
        }
        return false
    }
    
    
    
    //////////////////////////////////////////////////////////////////////////////////////
    
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
    var utf8Data: Data? {
        return data(using: .utf8)
    }
    
    var is_valid_email: Bool {
        let email_rx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let test = NSPredicate(format:"SELF MATCHES %@", email_rx)
        return test.evaluate(with: self)
    }
    
    var is_valid_url: Bool {
        if self.length > 3, self.contains("."), let _ = NSURL(string: self) as URL? {
            return true
        }
        return false
    }
    
    var url: URL? {
        if !is_valid_url {
            return nil
        }
        if self.hasPrefix("http://") || self.hasPrefix("https://") {
            return NSURL(string: self) as URL?
        } else {
            return NSURL(string: "http://\(self)") as URL?
        }
    }
    
    var formatted_gpa: String? {
        guard let value = Double(self) else {
            return nil
        }
        if !(value > 0 && value < 7) {
            return nil
        }
        return String(format: "%.2f", value)
    }
    
    var formatted_currency: String? {
        let price = NSNumber(value: (self as NSString).doubleValue)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: price)
    }
    
    
    
    
}
