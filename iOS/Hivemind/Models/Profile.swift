//
//  ProfileController.swift
//  Hivemind
//
//  Created by Alex Dai on 10/29/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class Profile {
    
    private(set) var total_investment: CGFloat
    private(set) var original_investment: CGFloat
    private(set) var transfer_request: CGFloat
    
    init(totalInvestment: CGFloat, originalInvestment: CGFloat, transferRequest: CGFloat) {
        self.total_investment = totalInvestment
        self.original_investment = originalInvestment
        self.transfer_request = transferRequest
    }
    
    static func parse(json: ObjJSON) -> Profile? {
        guard
            let total_investment_raw    = json["total_investment"] as? String, let total_investment = Double(total_investment_raw),
            let original_investment_raw = json["original_investment"] as? String, let original_investment = Double(original_investment_raw),
            let transfer_request_raw    = json["transfer_request"] as? String, let transfer_request = Double(transfer_request_raw)
        else {
            debugPrint("Could not load Profile serializer")
            return nil
        }
        
        return Profile(totalInvestment: CGFloat(total_investment), originalInvestment: CGFloat(original_investment), transferRequest: CGFloat(transfer_request))
    }
}



