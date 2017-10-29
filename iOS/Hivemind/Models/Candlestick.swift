//
//  Candlestick.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/29/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class Candlestick {
    
    typealias OHLCArray = Array<(timestamp: Date, open: Double, high: Double, low: Double, close: Double, vwap: Double, volume: Double, count: Int)>
    private(set) var ohlc_array: OHLCArray
    private(set) var interval: API.KrakenInterval
    
    init(ohlcArray: OHLCArray, interval: API.KrakenInterval) {
        self.ohlc_array = ohlcArray
        self.interval = interval
    }
    
    static func parse(assetAPIName: String, interval: API.KrakenInterval, json: ObjJSON) -> Candlestick? {
        guard
            let _ = json["error"] as? [String],
            let result = json["result"] as? ObjJSON,
            let asset_array = result[assetAPIName] as? [AnyObject]
        else {
            debugPrint("Could not load Candlestick serializer")
            return nil
        }
        
        var ohlc_array: OHLCArray = []
        for ohlc_raw in asset_array {
            guard let ohlc = ohlc_raw as? [Any],
                let timestamp_raw = ohlc[0] as? Int,
                let open_raw = ohlc[1] as? String, let open = Double(open_raw),
                let high_raw = ohlc[2] as? String, let high = Double(high_raw),
                let low_raw = ohlc[3] as? String, let low = Double(low_raw),
                let close_raw = ohlc[4] as? String, let close = Double(close_raw),
                let vwap_raw = ohlc[5] as? String, let vwap = Double(vwap_raw),
                let volume_raw = ohlc[6] as? String, let volume = Double(volume_raw),
                let count_raw = ohlc[7] as? Int
            else {
                debugPrint("Couldn't parse a raw OHLC set")
                continue
            }
            
            ohlc_array.append((timestamp: Date(unixtime: TimeInterval(timestamp_raw)), open: open, high: high, low: low, close: close, vwap: vwap, volume: volume, count: count_raw))
        }
        
        return Candlestick(ohlcArray: ohlc_array, interval: interval)
    }
    
}

