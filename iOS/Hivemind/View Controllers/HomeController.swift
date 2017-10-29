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
    var current_preference: Preference? = nil
    
    var chart: Charter!
    var ticker_bar: TickerBar!
    
    /////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.charcoal
        view.isUserInteractionEnabled = true
        
        // Nav
        navigationController?.navigationBar.barTintColor = Color.white
        navigationController?.navigationBar.titleTextAttributes = Font.makeAttrs(size: ._18, color: Color.white, type: .rawengulkSans)
        navigationItem.rightBarButtonItem = NavButton(image: "nav_pie", selector: #selector(HomeController.goToPortfolio), target: self)
        navigationItem.leftBarButtonItem = NavButton(image: "nav_accordion", selector: #selector(HomeController.revealAssets), target: self)
        
        // Preference Bar
        let preference_bar_height = 0.13 * view.height
        preference_bar = PreferenceBar(frame: CGRect(x: 0, y: view.height - preference_bar_height, width: view.width, height: preference_bar_height))
        view.addSubview(preference_bar)
        
        // Ticker Bar
        let ticker_bar_height = 0.01 * view.height
        ticker_bar = TickerBar(frame: CGRect(x: 0, y: view.height - preference_bar_height - ticker_bar_height, width: view.width, height: ticker_bar_height))
        view.addSubview(ticker_bar)
        
        preference_bar.outer_circle_bear.addTarget(self, action: #selector(HomeController.goBearAnimated), for: .touchUpInside)
        preference_bar.outer_circle_bull.addTarget(self, action: #selector(HomeController.goBullAnimated), for: .touchUpInside)
        preference_bar.outer_circle_neutral.addTarget(self, action: #selector(HomeController.goNeutralAnimated), for: .touchUpInside)
        
        // Chart
        chart = Charter(frame: CGRect(x: 0, y: Utils.top_height, width: view.height, height: view.height - ticker_bar_height - preference_bar_height - Utils.top_height))
        view.addSubview(chart)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        API.getPreferences { status in
            DispatchQueue.main.async { [weak self] in
                switch status {
                case .success:
                    if let current_asset_string = UserDefaultsManager.readCurrentAsset() {
                        for preference in API.preferences {
                            if preference.asset.name == current_asset_string {
                                self?.current_preference = preference
                                break
                            }
                        }
                    } else if let preference = API.preferences[safe: 0] {
                        self?.current_preference = preference
                    }
                    
                    self?.populate()
                default:
                    debugPrint("Unexpected error with \(status)")
                }
            }
        }
    }
    
    
    func populate() {
        guard let current = self.current_preference else {
            debugPrint("No current preference is selected")
            return
        }
        self.adjust(preference: current.preference, animated: false)
        self.preference_bar.placeNeutralCircle(at: current.asset.bee_value ?? 0)
        
        // Get current asset from Kraken
        self.title = current.asset.name
        chart.loadData(assetAPIName: current.asset.api_name, interval: ._240)
    }
    
    
    @objc func revealAssets() {
        let alert = UIAlertController(title: "Which assets would you like to see?", message: nil, preferredStyle: .actionSheet)
        for preference in API.preferences {
            alert.addAction(UIAlertAction(title: preference.asset.name, style: .default)  { _ in
                self.current_preference = preference
                self.populate()
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func goToPortfolio() {
        let portfolio_controller = PortfolioController(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(portfolio_controller, animated: true)
    }
    
    
    private func update(preference: Preference.PreferenceType) {
        guard let current_asset = current_preference?.asset else {
            debugPrint("No current preference set")
            return
        }
        
        API.updatePreference(preference: preference, asset: current_asset) { status in
            DispatchQueue.main.async {
                if status != .success {
                    debugPrint("Unexpected error with \(status)")
                }
            }
        }
    }
    
    
    @objc func goBullAnimated() {
        adjust(preference: .bull, animated: true)
    }
    
    @objc func goBearAnimated() {
        adjust(preference: .bear, animated: true)
    }
    
    @objc func goNeutralAnimated() {
        adjust(preference: .neutral, animated: true)
    }
    
    func adjust(preference: Preference.PreferenceType, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.4 : 0, delay: 0, options: .allowUserInteraction, animations: { [weak self] in
            self?.preference_bar.changePreference(to: preference, duration: animated ? 0.4 : 0)
            self?.ticker_bar.backgroundColor = Color.resolve(preference)
            self?.navigationController?.navigationBar.barTintColor = Color.resolve(preference)
        })

        if animated, let current_preference = self.current_preference, current_preference.preference != preference {
            update(preference: preference)
        }
    }
    
    
}








