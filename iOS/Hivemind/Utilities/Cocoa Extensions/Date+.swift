//
//  Extensions.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

extension Date {
    
    init(iso8601 input: String) {
        let init_formatter = DateFormatter()
        init_formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        init_formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        self.init(timeInterval: 0, since: init_formatter.date(from: input)!)
    }
    
    init(topflight input: String) {
        let init_formatter = DateFormatter()
        init_formatter.timeZone = TimeZone(secondsFromGMT: 0)
        init_formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        init_formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        self.init(timeInterval: 0, since: init_formatter.date(from: input)!)
    }
    
    var midStyle: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    
    var shortStyle: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var timeSinceNow: String {
        if Calendar.current.isDateInYesterday(self) {
            return "Yesterday"
        }
        let formatter = DateFormatter()
        let seconds: TimeInterval = max(1.0, fabs(self.timeIntervalSinceNow))
        let days = seconds / 60.0 / 60.0 / 24.0
        if days < 1.0 {
            formatter.dateFormat = "h:mm a"
        } else if (days / 6.0) < 1.0 {
            formatter.dateFormat = "E"
        } else if (days / 364.0) < 1.0 {
            formatter.dateFormat = "MMM d"
        } else {
            formatter.dateFormat = "M/d/yyyy"
        }
        return formatter.string(from: self as Date)
    }
    
    
    
    var extendedTimeSinceNow: String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInYesterday(self) {
            formatter.dateFormat = "h:mm a"
            return "Yesterday, \(formatter.string(from: self as Date))"
        }
        
        let seconds: TimeInterval = max(1.0, fabs(self.timeIntervalSinceNow))
        let days = seconds / 60.0 / 60.0 / 24.0
        if days < 1.0 {
            formatter.dateFormat = "h:mm a"
        } else if (days / 6.0) < 1.0 {
            formatter.dateFormat = "E, h:mm a"
        } else if (days / 364.0) < 1.0 {
            formatter.dateFormat = "MMM d, h:mm a"
        } else {
            formatter.dateFormat = "M/d/yyyy"
        }
        return formatter.string(from: self as Date)
    }
    
    
    var stringSinceNow: String {
        if self.timeIntervalSinceNow > 0 {
            return "0 seconds ago"
        }
        let seconds: TimeInterval = max(1.0, fabs(self.timeIntervalSinceNow))
        if seconds < 60 {
            return "\(String(Int(seconds))) second\(Int(seconds) == 1 ? "" : "s") ago"
        }
        let minutes = seconds / 60.0
        if minutes < 60 {
            return "\(String(Int(minutes))) minute\(Int(minutes) == 1 ? "" : "s") ago"
        }
        let hours = minutes / 60.0
        if hours < 24 {
            return "\(String(Int(hours))) hour\(Int(hours) == 1 ? "" : "s") ago"
        }
        let days = hours / 24.0
        if days < 31 {
            return "\(String(Int(days))) day\(Int(days) == 1 ? "" : "s") ago"
        }
        let months = days / 31.0
        if months < 12 {
            return "\(String(Int(months))) month\(Int(months) == 1 ? "" : "s") ago"
        }
        let years = months / 12.0
        return "\(String(Int(years))) year\(Int(years) == 1 ? "" : "s") ago"
    }
    
}

