//
//  Animation.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class Animation {
    
    static let status_bubble_duration: TimeInterval = 1
    
    private static func statusBubble(in view: UIView, image: String) {
        let check_width = 0.7 * Utils.bar_height
        let background_width = 0.65 * Utils.bar_height
        
        let background = UIImageView(image: UIImage(named: "circle"))
        background.resize(newWidth: 1)
        background.alpha = 1
        background.makeCircular()
        view.addSubviewInCenter(background)
        
        let icon = UIImageView(image: UIImage(named: image))
        icon.alpha = 0
        icon.resize(newWidth: check_width)
        view.addSubviewInCenter(icon)
        
        UIView.animate(withDuration: 0.2 * status_bubble_duration) {
            icon.alpha = 1
        }
        
        UIView.animate(withDuration: 0.3 * status_bubble_duration) {
            background.resize(newWidth: background_width)
        }
        
        async(after: 0.3 * status_bubble_duration) {
            background.bubble(duration: 0.9, x: 1.1, y: 1.1, damping: 0.2, velocity: 0.001, options: [.allowUserInteraction, .curveEaseIn])
        }
        
        async(after: 0.75 * status_bubble_duration) {
            UIView.animate(withDuration: 0.25 * status_bubble_duration, animations: {
                icon.alpha = 0
                background.alpha = 0
            }, completion: { _ in
                icon.removeFromSuperview()
                background.removeFromSuperview()
            })
        }
    }
    
    
    static func success(in view: UIView) {
        statusBubble(in: view, image: "status_check")
    }
    
    static func failure(in view: UIView) {
        statusBubble(in: view, image: "status_x")
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////
    
    static let tutorial_duration: TimeInterval = 2.0
    
    static func tutorialAnimation(in view: UIView) {
        let background = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 0.4 * view.height))
        background.backgroundColor = Color.slate
        background.alpha = 0
        background.isUserInteractionEnabled = false
        view.addSubviewInCenter(background)
        background.makeShadow()
        
        let label = UILabel()
        label.attributedText = Font.make(text: "Swipe to view more listings", size: ._16, color: Color.white)
        label.textAlignment = .center
        label.sizeToFit()
        label.alpha = 0
        view.addSubviewInCenter(label)
        
        let tutorial = UIImageView(image: UIImage(named: "tutorial"))
        tutorial.resize(newWidth: 0.3 * Utils.screen.width)
        tutorial.alpha = 0
        view.addSubviewInCenter(tutorial)
        
        label.center.y += 0.14 * view.height
        tutorial.center.y -= 0.05 * view.height
        tutorial.center.x += 0.18 * Utils.screen.width
        
        UIView.animate(withDuration: 0.2 * tutorial_duration) {
            tutorial.alpha = 1
            label.alpha = 1
            background.alpha = 1
        }
        
        UIView.animate(withDuration: 0.7 * tutorial_duration, delay: 0.15 * tutorial_duration, options: .curveEaseInOut, animations: {
            tutorial.center.x -= 0.4 * Utils.screen.width
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2 * tutorial_duration, delay: 0.8 * tutorial_duration, animations: {
            tutorial.alpha = 0
            background.alpha = 0
            label.alpha = 0
        }, completion: { _ in
            tutorial.removeFromSuperview()
            background.removeFromSuperview()
            label.removeFromSuperview()
        })
    }
    
    
}
