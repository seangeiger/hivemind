//
//  Field.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/29/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class Field: UITextField {
    
    var separator: UIView!
    var label = UILabel()
    
    var titles:               [String] = []
    var clear_types:          [UITextFieldViewMode] = []
    var keyboard_types:       [UIKeyboardType] = []
    var return_types:         [UIReturnKeyType] = []
    var autocorrect_types:    [UITextAutocorrectionType] = []
    var autocapitalize_types: [UITextAutocapitalizationType] = []
    var security_types:       [Bool] = []
    var dropdowns:            [Bool] = []
    
    
    //////////////////////////////////////////////////////////////////////////////////
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    init(frame: CGRect, textColor: UIColor) {
        super.init(frame: frame)
        self.defaultTextAttributes = Font.makeLegacyAttrs(size: ._18, color: textColor)
        self.returnKeyType = .done
        
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: 1.05 * self.width, height: 0.5))
        separator.backgroundColor = Color.gray
        separator.center = CGPoint(x: self.bounds.midX, y: 0.7 * self.height)
        separator.isUserInteractionEnabled = false
        self.addSubview(separator)
        
        label.frame = self.frame
        label.alpha = 0
        label.isUserInteractionEnabled = false
        label.center = CGPoint(x: self.bounds.midX, y: 0.25 * self.height)
        self.addSubview(label)
        
        self.addTarget(self, action: #selector(Field.textFieldDidChange), for: .editingChanged)
    }
    
    
    @objc func textFieldDidChange() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            if let text = self.text, text != "" {
                self.label.alpha = 1
            } else {
                self.label.alpha = 0
            }
        }, completion: nil)
    }
    
    func set(state: Int) {
        if let title = self.titles[safe: state] {
            self.attributedPlaceholder = Font.make(text: title, size: ._18, color: .gray)
            self.label.attributedText  = Font.make(text: title, size: ._12, color: .gray)
        }
        if let keyboard_type = self.keyboard_types[safe: state] {
            self.keyboardType = keyboard_type
        }
        if let return_key_type = self.return_types[safe: state] {
            self.returnKeyType = return_key_type
        }
        if let autocorrect_type = self.autocorrect_types[safe: state] {
            self.autocorrectionType = autocorrect_type
        }
        if let security_type = self.security_types[safe: state] {
            self.isSecureTextEntry = security_type
        }
        if let clear_type = self.clear_types[safe: state] {
            self.clearButtonMode = clear_type
        }
        if let capitalize_type = self.autocapitalize_types[safe: state] {
            self.autocapitalizationType = capitalize_type
        }
    }
    
    
    
}


class FieldBar: UIView, UITextFieldDelegate {
    
    var field  = UITextField()
    let button = ClosureButton()
    
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Color.slate
        self.makeShadow()
        
        field.clearButtonMode = .always
        
        self.addSubview(field)
        self.addSubview(button)
    }
    
    
    override func resignFirstResponder() -> Bool {
        _ = super.resignFirstResponder()
        return self.field.resignFirstResponder()
    }
    
    
}


