//
//  Timein.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

// General class for enforcing minumum times on events (the opposite of a timeout)
class Timein {
    
    private var timer = Timer()
    private var hit_min_wait_time = false
    private var did_stop = false
    
    private var interval: TimeInterval
    
    internal(set) var status: Status = .none
    
    enum Status {
        case none
        case success
        case failure
    }
    
    var startAction:  VoidBlock?
    var finishAction: VoidBlock?
    
    
    /////////////////////////////////////////////////////////////////////////////////
    
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    init(startAction: VoidBlock?, finishAction: VoidBlock?, interval: TimeInterval = 0.5) {
        self.startAction  = startAction
        self.finishAction = finishAction
        self.interval = interval
    }
    
    
    @objc internal func hitMinWaitTime() {
        DispatchQueue.main.async {
            self.hit_min_wait_time = true
            if self.did_stop {
                self.finishAction?()
            }
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    
    
    // Override & call for more start animation functionality
    func start() {
        hit_min_wait_time = false
        did_stop = false
        self.timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(self.hitMinWaitTime), userInfo: nil, repeats: false)
        self.startAction?()
    }
    
    
    // Override & call for more stop animation functionality
    func stop(status: Status) {
        self.status = status
        DispatchQueue.main.async {
            self.did_stop = true
            if self.hit_min_wait_time {
                self.finishAction?()
            }
        }
    }
    
}







