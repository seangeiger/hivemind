//
//  General.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class AssetCell: UITableViewCell {
    
    ///////////////////////////////////////////////////////////////
    
    class var height: CGFloat { return 100 }
    
    let position_block = UIView()
    var label_asset_price: SmartLabel!
    var label_asset_name: SmartLabel!
    let separator = UIView()
    
    
    ///////////////////////////////////////////////////////////////
    
    required init?(coder aDecoder: NSCoder) {fatalError("No init(coder:)")}
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        
        separator.bounds = CGRect(x: 0.5 * self.bounds.width, y: 0, width: 2 * self.width, height: 0.5)
        separator.backgroundColor = Color.gray
        
        label_asset_price = SmartLabel(frame: CGRect(x: 0, y: 0, width: self.width, height: AssetCell.height), alignment: .center, text: nil)
        label_asset_name = SmartLabel(frame: CGRect(x: 0, y: 0, width: self.width, height: AssetCell.height), alignment: .left, text: nil)
        position_block.frame = CGRect(x: 0, y: 0, width: 0.2 * self.width, height: 0.5 * AssetCell.height)
        position_block.makeRound(radius: 2)
        
        self.contentView.addSubview(label_asset_name)
        self.contentView.addSubview(label_asset_price)
        self.contentView.addSubview(position_block)
        self.contentView.addSubview(separator)
    }
    
    
    func update(asset: Asset, preference: Preference.PreferenceType) {
        separator.center = CGPoint(x: self.center.x, y: 0.994 * self.height)
        
        label_asset_name.attributedText = Font.make(text: asset.api_name, size: ._20, color: Color.white)
        label_asset_price.attributedText = Font.make(text: String(asset.price), size: ._18, color: Color.white)
        label_asset_name.center = CGPoint(x: 0.2 * self.bounds.width, y: 0.5 * self.bounds.height)
        position_block.center = CGPoint(x: 0.7 * self.bounds.width, y: 0.5 * self.bounds.height)
        position_block.backgroundColor = Color.resolve(preference)
        label_asset_price.center = position_block.center
    }
    
    func setSeparator(visible: Bool) {
        separator.alpha = visible ? 1 : 0
    }
    
    
}
