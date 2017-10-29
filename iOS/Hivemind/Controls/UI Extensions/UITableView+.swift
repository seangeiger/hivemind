//
//  UITableView+.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/28/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

extension UITableView {
    
    func deselectSelectedRow(animated: Bool = true) {
        if let indexPathForSelectedRow = self.indexPathForSelectedRow {
            UIView.animate(withDuration: animated ? 0.3 : 0, delay: animated ? 0.3 : 0, options: .curveEaseInOut, animations: {
                self.deselectRow(at: indexPathForSelectedRow, animated: false)
            }, completion: nil)
        }
    }
    
    func performUpdate(_ update: VoidBlock, completion: VoidBlock?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        beginUpdates()
        update()
        endUpdates()
        CATransaction.commit()
    }
    
    
    // Adjust the visibility of AssetCell's custom cell separators, return if the display is empty
    func adjustSeparators() -> Bool {
        var is_display_empty = true
        
        for section in 0..<self.numberOfSections {
            if self.numberOfRows(inSection: section) == 0 {
                continue
            }
            is_display_empty = false
            
            // Check cell separators
            for row in 0..<self.numberOfRows(inSection: section) {
                if let cell = self.cellForRow(at: IndexPath(row: row, section: section)) as? AssetCell {
                    if row == self.numberOfRows(inSection: section) - 1 && section != self.numberOfSections - 1 {
                        cell.setSeparator(visible: false)
                    } else {
                        cell.setSeparator(visible: true)
                    }
                }
            }
        }
        
        return is_display_empty
    }

}
