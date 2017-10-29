//
//  Portfolio.swift
//  Hivemind
//
//  Created by Alex Dai on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class Portfolio {
    
	private(set) var total_investment: CGFloat
	private(set) var uninvested: CGFloat
    
	init(totalInvestment: CGFloat, uninvested: CGFloat) {
		self.total_investment = totalInvestment
		self.uninvested = uninvested
	}
	
	static func parse(json: ObjJSON) -> Portfolio? {
        guard
			let total_investment_raw = json["totalInvestment"] as? String, let total_investment = Double(total_investment_raw),
			let uninvested_raw		  = json["uninvested"] as? String, let uninvested = Double(uninvested_raw)
        else {
            debugPrint("Could not load Portfolio serializer")
            return nil
        }
				
        return Portfolio(totalInvestment: CGFloat(total_investment), uninvested: CGFloat(uninvested))
	}
}
