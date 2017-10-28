//
//  Alert.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

class Alert {
    
    static func general(status: ActionStatus) {
        make(title: nil, message: nil, status: status, defaultOK: true, actions: nil, fields: nil, callback: nil)?.show()
    }
    
    
    static func general(status: ActionStatus, replacements: [String]) {
        let message = getText(status: status).1.successiveReplace(with: replacements)
        make(title: nil, message: message, status: status, defaultOK: true, actions: nil, fields: nil, callback: nil)?.show()
    }
    
    static func general(title: String, message: String?, fields: [String], callback: @escaping ([String]) -> ()) {
        make(title: title, message: message, status: nil, defaultOK: false, actions: nil, fields: fields, callback: callback)?.show()
    }
    
    
    static func general(title: String, message: String?, fields: [String],actions: [UIAlertAction], callback: @escaping ([String]) -> ()) {
        make(title: title, message: message, status: nil, defaultOK: false, actions: actions, fields: fields, callback: callback)?.show()
    }
    
    
    static func general(status: ActionStatus?, title: String? = nil, message: String? = nil, defaultOK: Bool = true,
                        actions: [UIAlertAction]? = nil, replacements: [String]? = nil,
                        fields: [String]? = nil, callback: (([String]) -> ())? = nil) {
        
        var message = message
        if let replacements = replacements, let status = status {
            message = getText(status: status).1.successiveReplace(with: replacements)
        }
        
        make(title: title, message: message, status: status, defaultOK: defaultOK, actions: actions, fields: fields, callback: callback)?.show()
    }
    
    
    
    /////////////////////////////////////////////////////////////////////////////////
    
    // Auxiliary Methods //
    
    private static func getText(status: ActionStatus) -> (String, String) {
        return ActionDescription[status] ?? ("No Status", "Your current status is unrecognized. Please try again.")
    }
    
    
    private static func make(title: String?, message: String?, status: ActionStatus?, defaultOK: Bool,
                             actions: [UIAlertAction]?, fields: [String]?, callback: (([String]) -> ())?) -> UIAlertController? {
        
        if let status = status, status == .cancelled {
            debugPrint("Task cancelled")
            return nil
        }
        
        var alert: UIAlertController!
        if let title = title {
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        } else if let status = status {
            let prompt = getText(status: status)
            alert = UIAlertController(title: title ?? prompt.0, message: message ?? prompt.1, preferredStyle: .alert)
        } else {
            debugPrint("Cannot alert with no status or text!")
            return nil
        }
        
        // Add Text Fields
        if let fields = fields, let callback = callback {
            for field in fields {
                alert.addTextField { (textField: UITextField!) in textField.placeholder = field }
            }
            
            alert.addAction(UIAlertAction(title: "Submit", style: .default) { _ in
                var strings: [String] = []
                if let subfields = alert.textFields {
                    for subfield in (subfields as [UITextField]) {
                        if let text = subfield.text {
                            strings.append(text)
                        }
                    }
                }
                callback(strings)
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
        
        
        // Add actions
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        }
        
        // Add the default OK actions
        if defaultOK {
            alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
                if let status = status, status == .badtoken {
                    API.logout()
                }
            })
        }
        
        return alert
    }
    
    
    
    /////////////////////////////////////////////////////////////////////////////////
    
    // Ribbons //
    
    private static func ribbon(message: String, color: UIColor, viewToShift: UIView?) {
        guard let viewcontroller = UIViewController.current else {
            return
        }
        
        let background = UIView(frame: CGRect(x: 0, y: 0, width: Utils.screen.width, height: 0.06 * Utils.screen.height))
        background.backgroundColor = color
        background.addSubviewInCenter(SmartLabel(frame: background.frame, alignment: .center, text: Font.make(text: message, size: ._12, color: Color.white)))
        background.center = CGPoint(x: 0.5 * Utils.screen.width, y: Utils.top_height - 0.5 * background.height)
        
        if let nav_bar = (viewcontroller as? UINavigationController)?.navigationBar {
            viewcontroller.view.insertSubview(background, belowSubview: nav_bar)
        } else if let nav_bar = viewcontroller.navigationController?.navigationBar {
            viewcontroller.view.insertSubview(background, belowSubview: nav_bar)
        } else {
            viewcontroller.view.addSubview(background)
        }
        
        UIView.animate(withDuration: 0.4) {
            background.center.y   += background.height
            viewToShift?.center.y += background.height
        }
        
        async(after: 2.2) {
            UIView.animate(withDuration: 0.4, delay: 0, animations: {
                background.center.y   -= background.height
                viewToShift?.center.y -= background.height
            }, completion: { _ in
                background.removeFromSuperview()
            })
        }
    }
    
    
    static func successRibbon(message: String, viewToShift: UIView? = nil) {
        ribbon(message: message, color: Color.green, viewToShift: viewToShift)
    }
    
    
    static func failureRibbon(message: String, viewToShift: UIView? = nil) {
        ribbon(message: message, color: Color.red, viewToShift: viewToShift)
    }
    
}






