//
//  API+Kraken.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/29/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

extension API {
    
    enum KrakenInterval: Int {
        case _1 = 1
        case _5 = 5
        case _15 = 15
        case _30 = 30
        case _60 = 60
        case _240 = 240
        case _1440 = 1440
        case _10080 = 10089
        case _21600 = 21600
    }
    
    static func getOHLC(assetAPIName: String, interval: KrakenInterval, callback: @escaping (ActionStatus, Candlestick?) -> ()) {
        let body: HardJSON = ["pair": assetAPIName, "interval": Int(interval.rawValue)] as HardJSON
        
        API.post(key: "kraken_\(assetAPIName)_\(interval.rawValue)", absoluteURL: Networking.base_kraken, body: body, auth: false) { status, json in
            if status != .success {
                callback(status, nil)
            } else if let json = json as ObjJSON?, let candlestick = Candlestick.parse(assetAPIName: assetAPIName, interval: interval, json: json) {
                callback(status, candlestick)
            } else {
                callback(.unrecognized, nil)
            }
        }
    }
    
    
    
    
    
    
    
    
    
}
