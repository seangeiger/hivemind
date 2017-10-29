//
//  PreferenceBar.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import UIKit

class PreferenceBar: UIView {
    
    enum Preference {
        case bull
        case bear
        case neutral
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    
    let icon_bull = UIImageView(image: UIImage(named: "icon_bull")?.withRenderingMode(.alwaysTemplate))
    let icon_bear = UIImageView(image: UIImage(named: "icon_bear")?.withRenderingMode(.alwaysTemplate))
    let outer_circle_bull = ClosureButton()
    let outer_circle_bear = ClosureButton()
    let outer_circle_neutral = ClosureButton()
    let inner_circle_bull = UIView()
    let inner_circle_bear = UIView()
    let inner_circle_neutral = UIView()

    let center_line = UIView()
    let preference_line = UIView()
    

    ////////////////////////////////////////////////////////////////////////////////
    
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    
    func initUI() {
        self.backgroundColor = Color.charcoal
        
        let preference_line_width = 0.8 * self.width
        preference_line.frame = CGRect(x: 0, y: 0, width: preference_line_width, height: 0.017 * self.height)
        preference_line.backgroundColor = Color.grey
        self.addSubviewInCenter(preference_line)
        
        let center_line = UIView(frame: CGRect(x: 0, y: 0, width: 0.005 * self.width, height: 0.33 * self.height))
        center_line.backgroundColor = Color.gray
        self.addSubviewInCenter(center_line)
        
        // Preference Sizings
        let outer_circle_width = 0.15 * self.width
        let inner_circle_width = 0.9 * outer_circle_width
        let animal_width = 0.7 * outer_circle_width
        outer_circle_bear.frame = CGRect(x: 0, y: 0, width: outer_circle_width, height: outer_circle_width)
        outer_circle_bull.frame = CGRect(x: 0, y: 0, width: outer_circle_width, height: outer_circle_width)
        inner_circle_bear.frame = CGRect(x: 0, y: 0, width: inner_circle_width, height: inner_circle_width)
        inner_circle_bull.frame = CGRect(x: 0, y: 0, width: inner_circle_width, height: inner_circle_width)
        icon_bear.frame = CGRect(x: 0, y: 0, width: animal_width, height: animal_width)
        icon_bull.frame = CGRect(x: 0, y: 0, width: animal_width, height: animal_width)

        // Preference Placements
        outer_circle_bull.addSubviewInCenter(inner_circle_bull)
        outer_circle_bull.addSubviewInCenter(icon_bull)
        outer_circle_bear.addSubviewInCenter(inner_circle_bear)
        outer_circle_bear.addSubviewInCenter(icon_bear)
        
        outer_circle_bear.center = CGPoint(x: preference_line.frame.minX, y: self.mid.y)
        outer_circle_bull.center = CGPoint(x: preference_line.frame.maxX, y: self.mid.y)
        outer_circle_bear.makeCircular()
        outer_circle_bull.makeCircular()
        inner_circle_bear.makeCircular()
        inner_circle_bull.makeCircular()
        self.addSubview(outer_circle_bear)
        self.addSubview(outer_circle_bull)
        
        // Neutral position
        let outer_circle_neutral_width = 0.075 * self.width
        let inner_circle_neutral_width = 0.9 * outer_circle_neutral_width
        outer_circle_neutral.frame = CGRect(x: 0, y: 0, width: outer_circle_neutral_width, height: outer_circle_neutral_width)
        inner_circle_neutral.frame = CGRect(x: 0, y: 0, width: inner_circle_neutral_width, height: inner_circle_neutral_width)
        outer_circle_neutral.center.y = preference_line.center.y
        outer_circle_neutral.addSubviewInCenter(inner_circle_neutral)
        outer_circle_neutral.makeCircular()
        inner_circle_neutral.makeCircular()
        self.addSubview(outer_circle_neutral)
        
        inner_circle_bull.isUserInteractionEnabled = false
        inner_circle_bear.isUserInteractionEnabled = false
        inner_circle_neutral.isUserInteractionEnabled = false
        icon_bear.isUserInteractionEnabled = false
        icon_bull.isUserInteractionEnabled = false
        outer_circle_neutral.isUserInteractionEnabled = true
        outer_circle_bull.isUserInteractionEnabled = true
        outer_circle_bear.isUserInteractionEnabled = true
        
        // State
        changePreference(to: .neutral, animated: false)
        placeNeutralCircle(at: 0.3)
    }
    
    func placeNeutralCircle(at position: CGFloat) {
        outer_circle_neutral.center.x = preference_line.frame.minX + position * preference_line.width
    }
    
    
    func changePreference(to preference: Preference, animated: Bool) {
        let duration = 0.4
        
        UIView.animate(withDuration: animated ? duration : 0, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { [weak self] in
            switch preference {
            case .bull:
                if animated {
                    self?.outer_circle_bull.bubble(duration: duration, options: .allowUserInteraction)
                }
                self?.outer_circle_bull.backgroundColor = Color.green_mid
                self?.outer_circle_bear.backgroundColor = Color.gray
                self?.inner_circle_bull.backgroundColor = Color.green_light
                self?.inner_circle_bear.backgroundColor = Color.white
                self?.icon_bull.tintColor = Color.white
                self?.icon_bear.tintColor = Color.red_dark
                
                self?.outer_circle_neutral.backgroundColor = Color.gray
                self?.inner_circle_neutral.backgroundColor = Color.white
            
            case .bear:
                if animated {
                    self?.outer_circle_bear.bubble(duration: duration,  options: .allowUserInteraction)
                }
                self?.outer_circle_bull.backgroundColor = Color.gray
                self?.outer_circle_bear.backgroundColor = Color.red_dark
                self?.inner_circle_bull.backgroundColor = Color.white
                self?.inner_circle_bear.backgroundColor = Color.red_light
                self?.icon_bull.tintColor = Color.green_dark
                self?.icon_bear.tintColor = Color.white
                
                self?.outer_circle_neutral.backgroundColor = Color.gray
                self?.inner_circle_neutral.backgroundColor = Color.white
                
            case .neutral:
                if animated {
                    self?.outer_circle_neutral.bubble(duration: duration, options: .allowUserInteraction)
                }
                
                self?.outer_circle_bull.backgroundColor = Color.gray
                self?.outer_circle_bear.backgroundColor = Color.gray
                self?.inner_circle_bull.backgroundColor = Color.white
                self?.inner_circle_bear.backgroundColor = Color.white
                self?.icon_bull.tintColor = Color.green_dark
                self?.icon_bear.tintColor = Color.red_dark
                
                self?.outer_circle_neutral.backgroundColor = Color.purple_4
                self?.inner_circle_neutral.backgroundColor = Color.purple_1
            }
        }, completion: nil)
    }
        
        
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if subview.frame.contains(point) {
                return true
            }
        }
        return false
    }
        
        
        
}







