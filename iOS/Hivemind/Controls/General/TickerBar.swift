//
//  Ticker.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import UIKit

class TickerBar: UIView {

    /////////////////////////////////////////////////////////////////////////////////
    
    let label = UILabel()
    
    
    /////////////////////////////////////////////////////////////////////////////////
    
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    
    func initUI() {
        self.backgroundColor = Color.green_light
        
        
        
        
    }

}
