//
//  PortfolioController.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/29/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import UIKit
import Charts

class PortfolioController: UIViewController {
    
    ///////////////////////////////////////////////////////////////

    var label_personal_total: SmartLabel!
    var label_personal_delta: SmartLabel!
    var label_portfolio_total: SmartLabel!

    var label_portfolio_title: SmartLabel!
    var label_portfolio_percentage: SmartLabel!
    
    
    ///////////////////////////////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        API.getUser { status in
            if status != .success {
                debugPrint("Couldn't get user info on profile screen")
            }
            
            API.getPositions { status in
                DispatchQueue.main.async { [weak self] in
                    
                    switch status {
                    case .success:
                        guard let portfolio = API.positions[safe: 0]?.portfolio, let personal_total = API.profile?.total_investment, let personal_original = API.profile?.original_investment
                        else {
                            debugPrint("Error extracting portfolio information")
                            return
                        }
                    
                        self?.adjustLabels(personalTotal: personal_total, personalOriginal: personal_original, portfolioTotal: portfolio.total_investment)
                    default:
                        debugPrint("Unexpected error: \(status)")
                    }
                }
            }
        }
        
    }
    
    @objc func navLeftPressed(sender: UIButton?) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func alertLogout() {
        let alert = UIAlertController(title: "Log Out?", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive) { _ in
            API.logout()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.show()
    }
    

    func initUI() {
        view.backgroundColor =  Color.charcoal
        
        // Nav
        self.title = "Portfolio"
        navigationController?.navigationBar.barTintColor = Color.purple_3
        navigationController?.navigationBar.titleTextAttributes = Font.makeAttrs(size: ._18, color: Color.white, type: .rawengulkSans)
        navigationItem.leftBarButtonItem = NavButton(image: "nav_back", selector: #selector(PortfolioController.navLeftPressed), target: self)
        navigationItem.rightBarButtonItem = NavButton(image: "nav_account", selector: #selector(PortfolioController.alertLogout), target: self)
        
        label_personal_total = SmartLabel(frame: CGRect(x: 0, y: 0, width: view.width, height: 0.2 * view.height), alignment: .center, text: nil)
        label_personal_delta = SmartLabel(frame: CGRect(x: 0, y: 0, width: view.width, height: 0.2 * view.height), alignment: .center, text: nil)
        label_portfolio_title = SmartLabel(frame: CGRect(x: 0, y: 0, width: view.width, height: 0.2 * view.height), alignment: .center,
                                           text: Font.make(text: "Total Portfolio", size: ._15, color: Color.gray))
        label_portfolio_total = SmartLabel(frame: CGRect(x: 0, y: 0, width: view.width, height: 0.2 * view.height), alignment: .center, text: nil)
        label_portfolio_percentage = SmartLabel(frame: CGRect(x: 0, y: 0, width: view.width, height: 0.2 * view.height), alignment: .center, text: nil)
        
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: 0.7 * view.width, height: 0.5))
        separator.alpha = 0.5
        separator.backgroundColor = Color.gray
        
        let y_positions: [CGFloat] = [0.15, 0.2, 0.25, 0.30, 0.34, 0.38]
        label_personal_total.center = CGPoint(x: view.mid.x, y: y_positions[0] * view.height)
        label_personal_delta.center = CGPoint(x: view.mid.x, y: y_positions[1] * view.height)
        label_portfolio_title.center = CGPoint(x: view.mid.x, y: y_positions[3] * view.height)
        label_portfolio_total.center = CGPoint(x: view.mid.x, y: y_positions[4] * view.height)
        label_portfolio_percentage.center = CGPoint(x: view.mid.x, y: y_positions[5] * view.height)
        separator.center = CGPoint(x: view.mid.x, y: y_positions[2] * view.height)
        view.addSubview(separator)
        view.addSubview(label_personal_total)
        view.addSubview(label_personal_delta)
        view.addSubview(label_portfolio_title)
        view.addSubview(label_portfolio_total)
        view.addSubview(label_portfolio_percentage)
        
        // Spoof data
        //adjustLabels(personalTotal: 1192, personalOriginal: 900, portfolioTotal: 53478)
    }
    
    func adjustLabels(personalTotal: CGFloat, personalOriginal: CGFloat, portfolioTotal: CGFloat) {
        guard let personal_total = personalTotal.description.formatted_currency, let portfolio_total = portfolioTotal.description.formatted_currency else {
            debugPrint("Could not convert portfolio totals into currency")
            return
        }
        
        let personal_equity = personalTotal / portfolioTotal
        let personal_delta = personalTotal / personalOriginal - 1.0
        
        let portfolio_percentage = String(format:"%.2f", personal_equity) + "%"
        label_personal_total.attributedText = Font.make(text: personal_total, size: ._30, color: Color.white)
        label_portfolio_total.attributedText = Font.make(text: portfolio_total, size: ._24, color: Color.white)
        label_portfolio_percentage.attributedText = Font.make(text: portfolio_percentage, size: ._15, color: Color.gray)
        
        if personal_delta < 1 {
            label_personal_delta.attributedText = Font.make(text: "-" + String(format:"%.2f", personal_delta) + "%", size: ._20, color: Color.red_light)
        } else {
            label_personal_delta.attributedText = Font.make(text: "+" + String(format:"%.2f", personal_delta) + "%", size: ._20, color: Color.green_light)
        }
    }
    
    
}
