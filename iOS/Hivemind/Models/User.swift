//
//  User.swift
//  Hivemind
//
//  Created by Alex Dai on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class User {
    
	private(set) var id: Int
    private(set) var username: String
	private(set) var total_investment: Double
	private(set) var original_investment: Double
	private(set) var transfer_request: Double
	private(set) var preferences: [Preference]
	
	init(id: Int, username: String, totalInvestment: Double, originalInvestment: Double, transferRequest: Double, preferences: [Preference]) {
		self.id = id
		self.username = username
		self.total_investment = total_investment
		self.original_investment = original_investment
		self.transfer_request = transfer_request
		self.preferences = preferences
	}
	
	static func parse(json: ObjJSON) -> User? {
		guard
			let id					= json["id"] as? Int,
			let username			= json["username"] as? String,
			let total_investment	= json["total_investment"] as? Double, 
			let original_investment	= json["original investment"] as? Double, 
			let transfer_request	= json["transfer_request"] as? Double, 
			let preferences_raw 	= json["preferences"] as? [ObjJSON]
		else {
			debugPrint("Could not load User serializer")
			return nil
		}
		
		var preferences: [Preference] = []
        for element in preferences_raw {
			if let preference = Preference.parse(json: element) {
				preferences.append(preference)
			}
        }
		
		return User(id: id, username: username, totalTnvestment: total_investment, originalInvestment: original_investment, transferRequest: transfer_request, preferences: preferences)
	}
}
