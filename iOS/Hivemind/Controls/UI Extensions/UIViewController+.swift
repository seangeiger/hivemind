//
//  ViewController+.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

extension UIViewController {
    
    // Application screen types (for transitions)
    static var current_screen: Screen = .unknown
    enum Screen {
        case login
        case splash
        case home
        case profile
        case unknown
    }
    
    // Returns the most recently presented UIViewController (visible)
    static var current: UIViewController? {
        if let navigationController = UIViewController.navigator {
            return navigationController.visibleViewController
        }
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while currentController.presentedViewController != nil {
                currentController = currentController.presentedViewController
            }
            return unwrapNavigator(controller: currentController)
        }
        return nil
    }
    
    static var navigator: UINavigationController? {
        let root_controller = UIApplication.shared.keyWindow?.rootViewController
        if let nav_controller = root_controller?.navigationController {
            return nav_controller
        }
        return root_controller as? UINavigationController
    }
    
    // Auxiliary Methods //
    
    private static func unwrapNavigator(controller: UIViewController?) -> UIViewController? {
        if let navigator = controller as? UINavigationController {
            return navigator.visibleViewController
        }
        return controller
    }
    
}






