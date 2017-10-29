//
//  Position.swift
//  Hivemind
//
//  Created by Alex Dai on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class Position {
    
	private(set) var asset_amount: Double
	private(set) var portfolio_percentage: Double
	private(set) var asset: Asset
    private(set) var portfolio: Portfolio
	
    init(assetAmount: Double, portfolioPercentage: Double, asset: Asset, portfolio: Portfolio) {
		self.asset_amount = assetAmount
		self.portfolio_percentage = portfolioPercentage
		self.asset = asset
        self.portfolio = portfolio
	}
	
	static func parse(json: ObjJSON) -> Position? {
		guard
			let asset_amount_raw	     = json["assetAmount"] as? String, let asset_amount = Double(asset_amount_raw),
			let portfolio_percentage_raw = json["portfolioPercentage"] as? String, let portfolio_percentage = Double(portfolio_percentage_raw),
			let asset_raw			     = json["asset"] as? ObjJSON,
			let asset 				     = Asset.parse(json: asset_raw),
            let portfolio_raw           = json["portfolio"] as? ObjJSON,
            let portfolio               = Portfolio.parse(json: portfolio_raw)
		else {
			debugPrint("Could not load Position serializer")
			return nil
		}
		
        return Position(assetAmount: asset_amount, portfolioPercentage: portfolio_percentage, asset: asset, portfolio: portfolio)
	}
}

