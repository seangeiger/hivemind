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
    private(set) var bee_value: CGFloat?
    
    init(name: String, apiName: String, price: Double) {
		self.name = name
		self.api_name = apiName
		self.price = price
	}
	
	static func parse(json: ObjJSON) -> Asset? {
        guard
			let name	  = json["name"] as? String,
			let api_name = json["api_name"] as? String,
			let price_raw = json["price"] as? String, let price = Double(price_raw)
		else {
			debugPrint("Could not load Asset serializer")
			return nil
		}
		
        let asset = Asset(name: name, apiName: api_name, price: price)
        if let bee_value_raw = json["bee_value"] as? String, let double_bee = Double(bee_value_raw) {
            asset.bee_value = CGFloat(double_bee)
        } else if let bee_value = json["bee_value"] as? Int {
            asset.bee_value = CGFloat(bee_value)
        }
        
        return asset
	}
    
    func toJSON() -> HardJSON {
        return ["name": name, "api_name": api_name, "price": price, "bee_value": bee_value ?? 0]
    }
    
    
}
