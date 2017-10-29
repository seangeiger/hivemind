//
//  Charter.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/29/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation
import Charts

class Charter: UIView {
    
    /////////////////////////////////////////////////////////////////////////////////
    
    let candle_chart = CandleStickChartView()
    
    
    /////////////////////////////////////////////////////////////////////////////////
    
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        getData(assetAPIName: "BCHXBT", interval: ._5)
    }
    
    func initUI() {
        self.backgroundColor = Color.blue
        
        candle_chart.frame = self.frame
        self.addSubviewInCenter(candle_chart)
    }
    
    func getData(assetAPIName: String, interval: API.KrakenInterval) {
        API.getOHLC(assetAPIName: assetAPIName, interval:interval, callback: { [weak self] status, candlestick in
            DispatchQueue.main.async { [weak self] in
                switch status {
                case .success:
                    if let candlestick = candlestick {
                        self?.createCandlestickChart(candlestick: candlestick)
                    } else {
                        Alert.general(status: .unrecognized)
                    }
                default:
                    Alert.general(status: status)
                }
            }
        })
    }
    
    
    func createCandlestickChart(candlestick: Candlestick) {
        var entries: [CandleChartDataEntry] = []
        
        for point in candlestick.ohlc_array.suffix(60) {
            entries.append(CandleChartDataEntry(x: point.0.timeIntervalSince1970, shadowH: point.2, shadowL: point.3, open: point.1, close: point.4))
        }
        
        candle_chart.data = CandleChartData(dataSet: CandleChartDataSet(values: entries, label: "Custom Label"))
        candle_chart.notifyDataSetChanged()
    }
    
    
    
    
    
    
}



