//
//  SplashController.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import UIKit

class SplashController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.yellow
        
        async(after: 3) {
            Utils.app_delegate.proceed(to: .home, animated: true)
        }
    }
    
    
}
