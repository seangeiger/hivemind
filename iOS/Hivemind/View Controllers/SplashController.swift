//
//  SplashController.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/29/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

class SplashController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.charcoal
        
        Utils.app_delegate.proceed(to: .home, animated: true)

        /*
        API.getUser { status in
            DispatchQueue.main.async {
                if status == .success {
                } else {
                    debugPrint("Can't load user")
                }
            }
        }
        */
    }

}
