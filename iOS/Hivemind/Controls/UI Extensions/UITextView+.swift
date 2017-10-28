//
//  UITextView+.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class TextViewPlus: UITextView {
    var attributedPlaceholder: NSAttributedString?
    var text_attributes: [ NSAttributedStringKey: Any]?
    var is_placeholder = false
}


extension UITextView {
    
    var visible_range: NSRange? {
        if let start = closestPosition(to: contentOffset) {
            if let end = characterRange(at: CGPoint(x: contentOffset.x + bounds.maxX, y: contentOffset.y + bounds.maxY))?.end {
                return NSMakeRange(offset(from: beginningOfDocument, to: start), offset(from: start, to: end))
            }
        }
        return nil
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func fitText(maxHeight: CGFloat, duration: TimeInterval) {
        let frame = self.frame
        let new_height = self.sizeThatFits(CGSize(width: self.width, height: CGFloat.greatestFiniteMagnitude)).height
        UIView.animate(withDuration: duration, animations: {
            let height = maxHeight > 0 ? min(maxHeight, new_height + 30) : new_height + 30
            self.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: height)
        }, completion: { _ in
            self.layoutIfNeeded()
        })
    }
    
    func centerTextVerically() {
        let content_size = self.sizeThatFits(CGSize(width: self.bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        let top_correction = (self.bounds.size.height - content_size.height * self.zoomScale) / 2.0
        self.contentOffset = CGPoint(x: 0, y: -top_correction)
    }
    
    
    func didBeginEditing() {
        if let me = self as? TextViewPlus, me.is_placeholder {
            self.attributedText = NSAttributedString(string: " ", attributes: me.text_attributes)
            me.is_placeholder = false
        }
    }
    
    
    func didEndEditing() {
        guard let me = self as? TextViewPlus else {
            return
        }
        
        let text = me.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty {
            me.attributedText = me.attributedPlaceholder
            me.is_placeholder = true
        } else {
            me.attributedText = Font.make(text: text, attributes: me.text_attributes!)
            me.is_placeholder = false
        }
    }
    
}


