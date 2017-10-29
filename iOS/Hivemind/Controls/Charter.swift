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
    
    func loadData(assetAPIName: String, interval: API.KrakenInterval) {
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
                    debugPrint("Unexpected error: \(status)")
                }
            }
        })
    }
    
    
    //////////////////////
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Color.charcoal
        
        candle_chart.frame = self.frame
        self.addSubviewInCenter(candle_chart)
        
        candle_chart.borderLineWidth = 0.1
        candle_chart.autoScaleMinMaxEnabled = true
        candle_chart.legend.enabled = false
    }
    
    private func createCandlestickChart(candlestick: Candlestick) {
        var entries: [CandleChartDataEntry] = []
        
        for point in candlestick.ohlc_array.suffix(60) {
            entries.append(CandleChartDataEntry(x: point.0.timeIntervalSince1970, shadowH: point.2, shadowL: point.3, open: point.1, close: point.4))
        }
        
        let dataset = CandleChartDataSet(values: entries, label: nil)
        dataset.decreasingColor = Color.red_light
        dataset.increasingColor = Color.green_mid
        dataset.barSpace = 0.5
        dataset.decreasingFilled = false
        dataset.decreasingFilled = false
        dataset.formLineWidth = 1
        dataset.shadowColorSameAsCandle = true
        dataset.neutralColor = Color.white
        
        
        candle_chart.data = CandleChartData(dataSet: dataset)
        candle_chart.data?.setDrawValues(false)
        candle_chart.notifyDataSetChanged()
    }
    
    
    
    
    
    
}



