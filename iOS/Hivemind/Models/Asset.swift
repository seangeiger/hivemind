//
//  Asset.swift
//  Hivemind
//
//  Created by Alex Dai on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class Asset { 
	
	private(set) var name: String
	private(set) var api_name: String
	private(set) var price: Double
	
	init(name: String, apiName: String, price: Double) {
		self.name = name
		self.api_name = apiName
		self.price = price
	}
	
	static func parse(json: [String: AnyObject]) -> Asset? {
		guard
			let id		 = json["name"] as? String,
			let api_name = json["api_name"] as? String,
			let price	  = json["price"] as? Double
		else {
			debugPrint("Could not load Asset serializer")
			return nil
		}
		
		return Asset(id: id, apiName: api_name, price: price)
	}
}
