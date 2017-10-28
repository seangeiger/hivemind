//
//  UI Extensions.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import UIKit

extension UILabel {
    func centerFit() {
        let center = self.center
        self.sizeToFit()
        self.center = center
    }
    
    func leftFit() {
        let frame = self.frame
        self.sizeToFit()
        self.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
    }
}


extension UIScrollView {
    func disable() {
        self.isUserInteractionEnabled = false
        self.setContentOffset(self.contentOffset, animated: false)
    }
    
    func enable() {
        self.isUserInteractionEnabled = true
    }
}


extension UIRefreshControl {
    
    // Note: this does NOT begin the actually refresh action. It does not call self.sendActions(for: UIControlEvents.valueChanged)
    func beginRefreshingManually(animated: Bool) {
        if let scrollView = superview as? UIScrollView {
            UIView.animate(withDuration: animated ? 0.3 : 0, delay: 0, options: .curveEaseInOut, animations: {
                scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - self.frame.height), animated: false)
            }, completion: nil)
        }
        self.beginRefreshing()
    }
    
}


extension UIAlertController {
    
    func show() {
        present(animated: true, completion: nil)
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    func leftJustify() {
        /* Doesn't work with Swift & iOS 8+ //  http://stackoverflow.com/questions/30481853/align-left-alertview-message-in-ios8-swift */
        for subview in self.view.subviews {
            if let label = subview as? UILabel {
                label.textAlignment = .left
            }
            if let textview = subview as? UITextView {
                textview.textAlignment = .left
            }
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController, let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        } else if let tabVC = controller as? UITabBarController, let selectedVC = tabVC.selectedViewController {
            presentFromController(controller: selectedVC, animated: animated, completion: completion)
        } else {
            controller.present(self, animated: animated, completion: completion)
        }
    }
    
}


extension UIColor {
    class func color(withData data: Data) -> UIColor {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! UIColor
    }
    
    func encode() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
}


extension UIViewController {
    var class_name: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
}








