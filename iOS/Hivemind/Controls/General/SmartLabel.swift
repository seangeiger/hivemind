//
//  SmartLabel.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class SmartLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    init(frame: CGRect, alignment: NSTextAlignment = .left, text: NSAttributedString? = nil) {
        super.init(frame: frame)
        self.numberOfLines = 1
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.8
        self.textAlignment = alignment
        if let text = text {
            self.attributedText = text
        }
    }
    
    
    
    
    
    
    
}
