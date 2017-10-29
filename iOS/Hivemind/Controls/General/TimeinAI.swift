//
//  TimeinActivityIndicator.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/29/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class TimeinActivityIndicator: UIActivityIndicatorView {
    
    var timein: Timein!
    var status: Timein.Status { get { return timein.status }}
    
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        timein = Timein(startAction: {
            self.startAnimating()
        }, finishAction: {
            self.stopAnimating()
        })
    }
    
    func start() {
        timein.start()
    }
    
    func stop(status: Timein.Status = .none) {
        timein.stop(status: status)
    }
    
}
