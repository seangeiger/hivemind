//
//  NavButton.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import UIKit

class NavButton: UIBarButtonItem {
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    init(image: String, selector: Selector, target: UIViewController) {
        let button_size = 0.5 * Utils.nav_height
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: button_size, height: button_size))
        button.setImage(UIImage(named: image), for: UIControlState())
        button.addTarget(target, action: selector, for: .touchUpInside)
        
        super.init()
        self.customView = button
        self.tintColor  = Color.white
    }
}
