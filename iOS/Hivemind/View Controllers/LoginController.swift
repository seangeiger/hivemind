//
//  LoginController.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import UIKit

class LoginController : UIViewController {
    
    var form: Form!
    
    var scroll_lock_on  = false
    
    var state: State = .login
    enum State: Int {
        case login = 0
        case register
        case count
    }
    
    enum Element: Int {
        case logo       = 101
        case username   = 2
        case password   = 3
        case confirm    = 4
        case initial    = 5
        case submit     = 102
        case button1    = 103
        case button2    = 104
        case ai         = 105
        case form       = 106
    }
    
    
    ///////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create form
        form = Form(states: State.count.rawValue)       // Must initialize here!
        form.backgroundColor = Color.charcoal
        form.frame = view.frame
        form.delegate = self
        form.tag = Element.form.rawValue
        
        // Add gestures to form
        let down = UISwipeGestureRecognizer(target: self, action: #selector(LoginController.endEditing))
        let tap  = UITapGestureRecognizer(target: self, action: #selector(LoginController.endEditing))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        down.direction = .down
        form.addGestureRecognizer(down)
        form.addGestureRecognizer(tap)
        
        // Add logo title (header) to form
        let logo = UIImageView(image: UIImage(named: "title_ondark"))
        logo.resize(newWidth: 0.6 * form.bounds.width)
        logo.isUserInteractionEnabled = false
        form.addView(tag: Element.logo.rawValue, view: logo, positions: [0.18 * view.bounds.height, 0.18 * view.bounds.height], enabled: [true, false])
        
        // Fields //
        
        form.addField(tag: Element.username.rawValue, delegate: self, textColor: Color.white, titles: ["Username", "Username"],
                      positions: [0.36 * view.bounds.height, 0.12 * view.bounds.height],
                      keyboardTypes: [.emailAddress], returnTypes: [.next, .next], autocorrectTypes: [.no, .no],
                      autocapitalizeTypes: [.none, .none], clearTypes: [.never, .never],
                      securityTypes: [false, false], enabled: [true, true], dropdowns: [false, false])
        
        form.addField(tag: Element.password.rawValue, delegate: self, textColor: Color.white, titles: ["Password", "Password"],
                      positions: [0.48 * view.bounds.height, 0.24 * view.bounds.height],
                      keyboardTypes: [.default], returnTypes: [.send, .next], autocorrectTypes: [.no, .no],
                      autocapitalizeTypes: [.none, .none], clearTypes: [.never, .never],
                      securityTypes: [true, true], enabled: [true, true], dropdowns: [false, false])
        
        form.addField(tag: Element.confirm.rawValue, delegate: self, textColor: Color.white, titles: ["XXX", "Confirm Password"],
                      positions: [0.36 * view.bounds.height, 0.36 * view.bounds.height],
                      keyboardTypes: [.default], returnTypes:  [.next, .next], autocorrectTypes: [.default, .default],
                      autocapitalizeTypes: [.words, .words], clearTypes: [.never, .never],
                      securityTypes: [true, true], enabled: [false, true], dropdowns: [false, false])
        
        form.addField(tag: Element.initial.rawValue, delegate: self, textColor: Color.white, titles: ["XXX", "Initial Amount"],
                      positions: [0.48 * view.bounds.height, 0.48 * view.bounds.height],
                      keyboardTypes: [.numberPad], returnTypes: [.next, .send], autocorrectTypes: [.default, .default],
                      autocapitalizeTypes: [.none, .none], clearTypes: [.never, .never],
                      securityTypes: [false, false], enabled: [false, true], dropdowns: [true, true])
        
        
        // Buttons //
        
        form.addButton(tag: Element.submit.rawValue, frame: CGRect(x: 0, y: 0, width: 0.85 * view.bounds.width, height: 0.06 * view.bounds.height),
                       titles: ["Log In", "Sign Up"],
                       positions: [0.58 * view.bounds.height, 0.58 * view.bounds.height],
                       enabled: [true, true],
                       action: { [weak self] (button) in self?.pressedSubmit(sender: button) })
        
        /*
        form.addButton(tag: Element.button1.rawValue, frame: CGRect(x: 0, y: 0, width: 0.8 * view.bounds.width, height: 0.1 * view.bounds.height),
                       titles: ["Forgot Password?", "Forgot Password?"],
                       positions: [0.855 * view.bounds.height, 0.855 * view.bounds.height],
                       enabled: [true, false],
                       action: { [weak self] (button) in self?.pressedButton1(sender: button) })
         */
 
        form.addButton(tag: Element.button2.rawValue, frame: CGRect(x: 0, y: 0, width: 0.8 * view.bounds.width, height: 0.1 * view.bounds.height),
                       titles: ["Create an account", "Already a member? Log in"],
                       positions: [0.93 * view.bounds.height, 0.93 * view.bounds.height],
                       enabled: [true, true],
                       action: { [weak self] (button) in self?.pressedButton2(sender: button) })
        
        let ai = TimeinActivityIndicator(frame:  CGRect(x: 0, y: 0 , width: 0.3 * view.bounds.width, height: 0.3 * view.bounds.width))
        form.addView(tag: Element.ai.rawValue, view: ai,
                     positions: [0.67 * view.bounds.height, 0.68 * view.bounds.height],
                     enabled: [true, true])
        
        // Set state
        view.addSubview(form)
        form.swap(toState: State.login.rawValue, duration: 0)
        self.state = .login
        checkButtons()
    }
    
    
    private func login() {
        let username = form.textFrom(tag: Element.username.rawValue)
        let password = form.textFrom(tag: Element.password.rawValue)
        if username.isEmpty || password.isEmpty {
            Alert.general(status: .missingfields)
            return
        }
        
        if username.length <= 4 {
            Alert.general(status: .bademail)
            return
        }
        
        self.form.setUI(enabled: false)
        
        async(after: 1) {
            Utils.app_delegate.proceed(to: .home, animated: true)
        }
    }
    
    
    private func signup() {
        let username = form.textFrom(tag: Element.username.rawValue)
        let password = form.textFrom(tag: Element.password.rawValue)
        let confirm  = form.textFrom(tag: Element.confirm.rawValue)
        let initial = form.textFrom(tag: Element.initial.rawValue)
        if username.isEmpty || password.isEmpty || confirm.isEmpty || initial.isEmpty {
            Alert.general(status: .missingfields)
            return
        }
        if username.length < 5 {
            Alert.general(status: .shortusername)
            return
        }
        if password.length < 8 {
            Alert.general(status: .shortpassword)
            return
        }
        if password != confirm {
            Alert.general(status: .nomatchpassword)
            return
        }
        
        self.form.setUI(enabled: false)

        async(after: 1) {
            self.form.setUI(enabled: true)
        }
    }

    func pressedSubmit(sender: UIButton?) {
        sender?.bubble()
        endEditing()
        
        if self.state == .login {
            self.login()
        } else if self.state == .register {
            self.signup()
        }
    }
    
    
    func pressedButton1(sender: UIButton?) {
        sender?.bubble()
        self.endEditing()
    }
    
    
    func pressedButton2(sender: UIButton?) {
        sender?.bubble()
        self.endEditing()
        
        if self.state == .register {
            form.swap(toState: State.login.rawValue)
            self.state = .login
        } else if self.state == .login {
            form.swap(toState: State.register.rawValue)
            self.state = .register
        }
        
        checkButtons()
    }
    
    
}



/////////////////////////////////////////////////////////////////////////////////

// Touches & Scrolls

extension LoginController: UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    @objc func endEditing() {
        view.endEditing(true)
        self.scrollTo(y: 0)
    }
    
    
    fileprivate func scrollTo(y: CGFloat) {
        scroll_lock_on = true
        UIView.animate(withDuration: 0.5, animations: {
            self.form.contentOffset = CGPoint(x: 0, y: y)
        }, completion: { _ in
            self.scroll_lock_on = false
        })
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let ignored_tags: [Int] = [Element.logo.rawValue, Element.ai.rawValue, Element.form.rawValue]
        if let touched_tag = touch.view?.tag, ignored_tags.contains(touched_tag) {
            return true
        }
        return false
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !scroll_lock_on {
            endEditing()
        }
    }
    
    
    func checkButtons() {
        switch self.state {
        case .login:
            let is_form_complete = !form.textFrom(tag: Element.username.rawValue).isEmpty && !form.textFrom(tag: Element.password.rawValue).isEmpty
            form.getButton(tag: Element.submit.rawValue)?.isEnabled = DEBUG_ON || is_form_complete
        case .register:
            let is_form_complete = !form.textFrom(tag: Element.username.rawValue).isEmpty  && !form.textFrom(tag: Element.password.rawValue).isEmpty &&
                !form.textFrom(tag: Element.confirm.rawValue).isEmpty && !form.textFrom(tag: Element.initial.rawValue).isEmpty
            form.getButton(tag: Element.submit.rawValue)?.isEnabled = DEBUG_ON || is_form_complete
        default:
            break
        }
    }
    
}


/////////////////////////////////////////////////////////////////////////////////

// Text Fields //

extension LoginController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.state == .login {
            switch textField.tag {
            case Element.username.rawValue:
                form.getField(tag: Element.password.rawValue)?.becomeFirstResponder()
            case Element.password.rawValue:
                self.pressedSubmit(sender: form.getButton(tag: Element.submit.rawValue))
            default: break
            }
            
        } else if self.state == .register {
            switch textField.tag {
            case Element.username.rawValue:
                form.getField(tag: Element.password.rawValue)?.becomeFirstResponder()
            case Element.password.rawValue:
                form.getField(tag: Element.confirm.rawValue)?.becomeFirstResponder()
            case Element.confirm.rawValue:
                form.getField(tag: Element.initial.rawValue)?.becomeFirstResponder()
            case Element.initial.rawValue:
                self.pressedSubmit(sender: form.getButton(tag: Element.button1.rawValue))
            default: break
            }
        }
        return false    // Do not want UITextField to insert line-breaks
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.center.y > 0.3 * form.height {
            self.scrollTo(y: textField.center.y - 0.3 * form.height)
        } else {
            self.scrollTo(y: 0)
        }
        return true
    }
    
}









