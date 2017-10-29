//
//  AppDelegate.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var is_first_launch = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Required initialization & customization
        UIApplication.shared.statusBarStyle = .lightContent
        Font.determineDevice(fromSize: Utils.screen)
        Utils.nav_height = UINavigationController().navigationBar.bounds.height
        
        // User Defaults
        if SAVE_KEYBOARD {
            Keyboard.shared.startListening(withHeight: UserDefaultsManager.readKeyboardHeight())
        } else {
            Keyboard.shared.startListening()
        }
 
        // Go to first screen
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if API.loadToken() || IGNORE_LOGIN {
            self.window?.rootViewController = SplashController(nibName: nil, bundle: nil)
        } else {
            self.window?.rootViewController = LoginController(nibName: nil, bundle: nil)
        }
        self.window?.makeKeyAndVisible()
        
        // Core Data actions
        if CACHE_IMAGES {
            CDImage.purgeExpired()
        } else {
            CDImage.purgeAll()
        }
        
        if DEBUG_ON {
            CDImage.printAll()
        }
        
        is_first_launch = false
        return true
    }

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions
    // > Incoming phone call or SMS message, or when the user quits the application and it begins the transition to the background state
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    func applicationWillResignActive(_ application: UIApplication) {
        API.pauseUpdates()
    }
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    func applicationDidEnterBackground(_ application: UIApplication) {
        runAppCloseBehavior()
    }
    
    
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    func applicationWillEnterForeground(_ application: UIApplication) {}
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    func applicationDidBecomeActive(_ application: UIApplication) {
        if !is_first_launch {
            API.startUpdates()
        }
    }
    
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground.
    func applicationWillTerminate(_ application: UIApplication) {
        runAppCloseBehavior()
    }
    
    
    private func runAppCloseBehavior() {
        CoreDataManager.shared.saveContext()
        
        if !SAVE_TOKEN {
            UserDefaultsManager.write(token: nil)
        }
        
        if !SAVE_CURRENT_ASSET {
            UserDefaultsManager.write(currentAsset: nil)
        }
        
        if SAVE_KEYBOARD {
            UserDefaultsManager.write(keyboardHeight: Keyboard.shared.height)
        } else {
            UserDefaultsManager.write(keyboardHeight: nil)
        }
        
        if !CACHE_IMAGES {
            CDImage.purgeAll()
        }
    }

    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // Root View Management //
    
    func snapshot(viewController: UIViewController) {
        DispatchQueue.main.async {
            let snapshot = self.window?.snapshotView(afterScreenUpdates: true)
            viewController.view.addSubview(snapshot!)
            self.window?.rootViewController = viewController
            UIView.animate(withDuration: 0.3, animations: {
                snapshot?.layer.opacity = 0
                snapshot?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }, completion: { _ in
                snapshot?.removeFromSuperview()
            })
        }
    }
    
    func exit() {
        snapshot(viewController: LoginController(nibName: nil, bundle: nil))
    }
    
    // View transitions when state is already set (i.e. not in appDidLaunch)
    
    func proceed(to screen: UIViewController.Screen, animated: Bool) {
        var view_controller: UIViewController!
        
        switch screen {
        case .home:
            let nav_controller = UINavigationController()
            nav_controller.viewControllers = [HomeController()]
            view_controller = nav_controller
            API.startUpdates()
        case .login:
            view_controller = LoginController()
            API.pauseUpdates()
        default:
            debugPrint("Transition to screen '\(screen)' not implemented in App Delegate")
        }
        
        if animated {
            snapshot(viewController: view_controller)
        } else {
            self.window?.rootViewController = view_controller
        }
    }

    
}








