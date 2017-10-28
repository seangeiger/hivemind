//
//  General.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class GeneralCell: UITableViewCell {
    
    let activity_indicator = UIActivityIndicatorView()
    let separator = UIView()
    
    required init?(coder aDecoder: NSCoder) {fatalError("No init(coder:)")}
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        
        separator.bounds = CGRect(x: 0.5 * self.bounds.width, y: 0, width: 2 * self.width, height: 0.5)
        separator.backgroundColor = Color.gray
        
        activity_indicator.activityIndicatorViewStyle = .gray
        
        self.contentView.addSubview(separator)
        self.contentView.addSubview(activity_indicator)
    }
    
    
    func update() {
        activity_indicator.center = CGPoint(x: 0.9 * self.width, y: 0.5 * self.height)
        separator.center = CGPoint(x: self.center.x, y: 0.994 * self.height)
    }
    
    
    func set(animating: Bool) {
        let _ = animating ? activity_indicator.startAnimating() : activity_indicator.stopAnimating()
    }
    
    func setSeparator(visible: Bool) {
        separator.alpha = visible ? 1 : 0
    }
    
    
    
}
