//
//  Form.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/29/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import UIKit

class Form: UIScrollView {
    
    fileprivate(set) var views: [Int : (UIView, [CGFloat], [Bool])] = [:]
    
    fileprivate(set) var buttons: [Int : [String]] = [:]
    fileprivate(set) var labels:  [Int : UILabel] = [:]
    
    fileprivate var states:        Int = 1
    fileprivate var current_state: Int = 0
    fileprivate var default_state: Int = 0
    
    private(set) var default_height_label:    CGFloat
    private(set) var default_height_textview: CGFloat
    
    var label_og_frame: CGRect? = nil
    var max_y: CGFloat = 0
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    required init?(coder aDecoder: NSCoder) {fatalError("No init(coder:)")}
    
    init(states: Int, frame: CGRect = CGRect(origin: CGPoint.zero, size: CGSize.zero), defaultState: Int = 0) {
        self.default_state = defaultState
        self.default_height_label    = 0.50 * Utils.bar_height
        self.default_height_textview = Utils.screen.height - Utils.top_height - Keyboard.shared.height
        
        super.init(frame: frame)
        self.states = states
        
        self.isUserInteractionEnabled = true
        self.isScrollEnabled = false
        self.autoresizingMask = .flexibleHeight
    }
    
    
    func addButton(tag: Int, frame: CGRect, titles: [String], positions: [CGFloat], enabled: [Bool], action: @escaping (UIButton) -> ()) {
        let button = ClosureButton(frame: frame) { button in action(button) }
        self.buttons[tag] = titles
        self.addView(tag: tag, view: button, positions: positions, enabled: enabled)
    }
    
    
    func addView(tag: Int, view: UIView, positions: [CGFloat], enabled: [Bool]) {
        view.tag = tag
        self.addSubview(view)
        self.views[tag] = (view, positions, enabled)
        
        if default_state > -1 {
            renderElement(tag: tag, toState: default_state)
        }
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    func getView(tag: Int) -> UIView? {
        return self.views[tag]?.0
    }
    
    func getButton(tag: Int) -> UIButton? {
        return getView(tag: tag) as? UIButton
    }
    
    func getField(tag: Int) -> Field? {
        return getView(tag: tag) as? Field
    }
    
    func getTextView(tag: Int) -> TextViewPlus? {
        return getView(tag: tag) as? TextViewPlus
    }
    
    
    func deleteView(tag: Int) {
        guard let view = self.views[tag] else {
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            view.0.removeFromSuperview()
            self.views.removeValue(forKey: tag)
        }
    }
    
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    func swap(toState state: Int, duration: TimeInterval = 0.4) {
        if state >= self.states {
            return
        }
        self.current_state = state
        
        max_y = 0
        for view in self.views {
            renderElement(tag: view.key, toState: state, duration: duration)
        }
        
        if max_y > Utils.screen.height {
            self.contentSize = CGSize(width: self.width, height: max_y + 0.1 * Utils.screen.height)
            self.isScrollEnabled = true
        } else {
            self.contentSize = Utils.screen
            self.isScrollEnabled = false
        }
    }
    
    
    private func renderElement(tag: Int, toState state: Int, duration: TimeInterval = 0) {
        guard let attr = self.views[tag], let y_position = attr.1[safe: state], let is_enabled = attr.2[safe: state] else {
            return
        }
        
        // Swap position
        let view = attr.0
        let current_max_y = y_position + 0.5 * view.height
        if current_max_y > max_y {
            max_y = current_max_y
        }
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState], animations: {
            view.center = CGPoint(x: self.bounds.midX, y: y_position)
            view.alpha = is_enabled ? 1 : 0
            if view is UITextField || view is UITextView {
                view.isUserInteractionEnabled = is_enabled
            }
        }, completion: nil)
        
        // Buttons
        if let button = attr.0 as? UIButton, let title = self.buttons[tag]?[safe: state] {
            let size: Font.SizeClass = title.length > 8 ? ._16 : ._18
            button.setAttributedTitle(Font.make(text: title, size: size, color: .white), for: .normal)
            button.setAttributedTitle(Font.make(text: title, size: size, color: .gray),  for: .disabled)
        }
        
        // Fields
        if let field = attr.0 as? Field {
            field.set(state: state)
        }
    }
    
    
    func setUI(enabled: Bool, tag: Int? = nil) {
        for view in self.views {
            if let ai = view.value.0 as? TimeinActivityIndicator {
                _ = enabled ? ai.stop() : ai.start()
            } else if let ai = view.value.0 as? UIActivityIndicatorView {
                _ = enabled ? ai.stopAnimating() : ai.startAnimating()
            }
            
            if let button = view.value.0 as? UIButton {
                button.isEnabled = enabled
            }
            if let field = view.value.0 as? UITextField {
                field.textColor = enabled ? Color.white : Color.gray
                field.isEnabled = enabled
            }
        }
    }
    
    
}


///////////////////////////////////////////////////////////////////////////////////////////

// Text Management //

extension Form {
    
    func addField(tag: Int, delegate: UITextFieldDelegate, textColor: UIColor, titles: [String], positions: [CGFloat],
                  keyboardTypes:       [UIKeyboardType],
                  returnTypes:         [UIReturnKeyType],
                  autocorrectTypes:    [UITextAutocorrectionType],
                  autocapitalizeTypes: [UITextAutocapitalizationType],
                  clearTypes:          [UITextFieldViewMode],
                  securityTypes:       [Bool],
                  enabled:             [Bool],
                  dropdowns:           [Bool]) {
        
        let field = Field(frame: CGRect(x: 0, y: 0, width: 0.85 * self.bounds.width, height: 0.15 * self.bounds.height), textColor: textColor)
        field.delegate = delegate
        
        field.clear_types = clearTypes
        field.keyboard_types = keyboardTypes
        field.titles = titles
        field.return_types = returnTypes
        field.autocorrect_types = autocorrectTypes
        field.security_types = securityTypes
        field.dropdowns = dropdowns
        field.autocapitalize_types = autocapitalizeTypes
        
        self.addView(tag: tag, view: field, positions: positions, enabled: enabled)
    }
    
    
    func setText(tag: Int, text: String) {
        if let field = self.getField(tag: tag) {
            field.text = text
            field.textFieldDidChange()
        } else if let textview = self.getTextView(tag: tag) {
            textview.text = text
        }
    }
    
    
    func textFrom(tag: Int) -> String {
        if let field_text = self.getField(tag: tag)?.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            return field_text
        } else if let textview = self.getTextView(tag: tag) {
            return textview.is_placeholder ? "" : textview.text
        }
        return ""
    }
    
    
    func textFieldsDidChange() {
        for view in self.views {
            if let field = view.value.0 as? Field {
                field.textFieldDidChange()
            }
        }
    }
    
    func textFieldDidChange(tag: Int) {
        if let field = self.getField(tag: tag) {
            field.textFieldDidChange()
        }
    }
    
    
    func makeViewRequired(tag: Int) {
        if let field = self.views[tag]?.0 as? Field, let title = field.titles[safe: self.current_state]{
            field.attributedPlaceholder = Font.make(text: title + " (Required)", size: ._18, color: .gray)
            field.label.attributedText  = Font.make(text: title + " (Required)", size: ._12, color: .gray)
            field.textFieldDidChange()
        } else if let textview = self.views[tag]?.0 as? TextViewPlus, let placeholder = textview.attributedPlaceholder?.string{
            textview.attributedPlaceholder = Font.make(text: placeholder + " (Required)", size: ._16, color: Color.gray)
        }
    }
    
}




