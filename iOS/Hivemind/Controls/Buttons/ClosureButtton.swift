//
//  ClosureButtton.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class ClosureButton: UIButton {
    var touchUpInside: ((_ sender: UIButton) -> ())?
    
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(touchUpInside(sender:)), for: .touchUpInside)
    }
    
    init(frame: CGRect, action: @escaping (_ button: UIButton) -> ()) {
        super.init(frame: frame)
        addTarget(self, action: #selector(touchUpInside(sender:)), for: .touchUpInside)
        self.touchUpInside = action
    }
    
    @objc func touchUpInside(sender: UIButton) {
        touchUpInside?(sender)
    }
}
