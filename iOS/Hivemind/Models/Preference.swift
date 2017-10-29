//
//  Preference.swift
//  Hivemind
//
//  Created by Alex Dai on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class Preference {
    
    enum PreferenceType: String {
        case bear = "BEAR"
        case bull = "BULL"
        case neutral = "BEE"
    }
    
	private(set) var preference: PreferenceType
	private(set) var asset: Asset
	
	init(preference: PreferenceType, asset: Asset) {
		self.preference = preference
		self.asset = asset
	}
	
	static func parse(json: ObjJSON) -> Preference? {
		guard
			let preference_raw = json["preference"] as? String,
            let preference     = PreferenceType(rawValue: preference_raw),
			let asset_raw      = json["asset"] as? ObjJSON,
			let asset		    = Asset.parse(json: asset_raw)
        else {
            debugPrint("Could not load Preference serializer")
            return nil
        }
        
		return Preference(preference: preference, asset: asset)
	}
    
    func set(type: PreferenceType) {
        self.preference = type
    }
    
}
