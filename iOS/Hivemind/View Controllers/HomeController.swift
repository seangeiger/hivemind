//
//  ViewController.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    /////////////////////////////////////////////////////////////////////////////////
    
    var preference_bar: PreferenceBar!

    
    /////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.charcoal
        view.isUserInteractionEnabled = true
        
        // Nav
        self.title = "BTX x USD"
        navigationController?.navigationBar.barTintColor = Color.purple_3
        navigationController?.navigationBar.titleTextAttributes = Font.makeAttrs(size: ._18, color: Color.white, type: .rawengulkSans)
        navigationItem.rightBarButtonItem = NavButton(image: "nav_pie", selector: #selector(HomeController.goToPortfolio), target: self)
        navigationItem.leftBarButtonItem = NavButton(image: "nav_accordion", selector: #selector(HomeController.revealAssets), target: self)
        
        // Preference Bar
        let preference_bar_height = 0.13 * view.height
        preference_bar = PreferenceBar(frame: CGRect(x: 0, y: view.height - preference_bar_height, width: view.width, height: preference_bar_height))
        view.addSubview(preference_bar)
        
        // Ticker Bar
        let ticker_bar_height = 0.04 * view.height
        let ticker_bar = TickerBar(frame: CGRect(x: 0, y: view.height - preference_bar_height - ticker_bar_height, width: view.width, height: ticker_bar_height))
        view.addSubview(ticker_bar)
        
        preference_bar.outer_circle_bear.addTarget(self, action: #selector(HomeController.goBear), for: .touchUpInside)
        preference_bar.outer_circle_bull.addTarget(self, action: #selector(HomeController.goBull), for: .touchUpInside)
        preference_bar.outer_circle_neutral.addTarget(self, action: #selector(HomeController.goNeutral), for: .touchUpInside)
        
        // Chart
        let chart = Charter(frame: CGRect(x: 0, y: Utils.top_height, width: view.height, height: view.height - ticker_bar_height - preference_bar_height - Utils.top_height))
        view.addSubview(chart)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // If API models have state and state update flags are false, re-populate. Otherwise update.
        update()
    }
    
    
    func update() {
        populate()
    }
    
    
    func populate() {
        
    }
    
    @objc func revealAssets() {
        
    
    }
    
    @objc func goToPortfolio() {
        
        
    }
    
    


}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Networking //

extension HomeController {
    
    @objc func goBull() {
        preference_bar.changePreference(to: .bull, animated: true)
    }
    
    @objc func goBear() {
        preference_bar.changePreference(to: .bear, animated: true)
    }
    
    @objc func goNeutral() {
        preference_bar.changePreference(to: .neutral, animated: true)
    }
    
    
}









