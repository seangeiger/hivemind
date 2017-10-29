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
	
	init(assetAmount: Double, portfolioPercentage: Double, asset: Asset) {
		self.asset_amount = assetAmount
		self.portfolio_percentage = portfolioPercentage
		self.asset = asset
	}
	
	static func parse(json: ObjJSON) -> Position? {
		guard
			let asset_amount	      = json["assetAmount"] as? Double,
			let portfolio_percentage = json["portfolioPercentage"] as? Double,
			let asset_raw			  = json["asset"] as? String,
			let asset 				  = Asset.parse(json: asset_raw)
		else {
			debugPrint("Could not load Position serializer")
			return nil
		}
		
		return Position(assetAmount: asset_amount, portfolioPercentage: portfolio_percentage, asset: asset)
	}
}

