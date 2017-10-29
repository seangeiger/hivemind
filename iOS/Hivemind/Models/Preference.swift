//
//  Preference.swift
//  Hivemind
//
//  Created by Alex Dai on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class Preference {
    
	private(set) var preference: String
	private(set) var asset: Asset
	
	init(preference: String, asset: Asset) {
		self.preference = preference
		self.asset = asset
	}
	
	static func parse(json: ObjJSON) -> Preference {
		guard
			let preference = json["preference"] as? String,
			let asset_raw  = json["asset"] as? String,
			let asset		= Asset.parse(json: asset_raw)
        else {
            debugPrint("Could not load Preference serializer")
            return nil
        }
        
		return Preference(preference: preference, asset: asset)
	}
    
}
