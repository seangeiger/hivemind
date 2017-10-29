//
//  Portfolio.swift
//  Hivemind
//
//  Created by Alex Dai on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class Portfolio {
    
	private(set) var total_investment: Double
	private(set) var uninvested: Double
	private(set) var positions: [Position]
	
	init(total_investment: Double, uninvested: Double, positions: [Position]) {
		self.total_investment = total_investment
		self.uninvested = uninvested
		self.positions = positions
	}
	
	static func parse(json: ObjJSON) -> Portfolio? {
        guard
			let total_investment	= json["total_investment"] as? Double, 
			let uninvested			= json["uninvested"] as? Double,
			let position_raw 		= json["positions"] as? [ObjJSON]
        else {
            debugPrint("Could not load Portfolio serializer")
            return nil
        }
		
		var position: [Position] = []
		for element in position_raw {
			if let position = Position.parse(json: element) {
				positions.append(position)
            }
		}
		
		return Portfolio(total_investment: total_investment, uninvested: uninvested, positions)
	}
}
