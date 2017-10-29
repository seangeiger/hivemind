//
//  AssetTable.swift
//  Hivemind
//
//  Created by Evan Kaminsky on 10/29/17.
//  Copyright © 2017 Hivemind. All rights reserved.
//

import Foundation

class AssetTable: UITableView {
    
    /*
    // Sections
    func numberOfSections(in: UITableView) -> Int {
        return 1
    }
    
    
    // Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table_data.count
    }
    
    
    // Heights
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MessagesCell.height
    }
    
    
    // Creation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let message = table_data[safe: indexPath.row] else {
            return UITableViewCell()
        }
        let cell = table.dequeueReusableCell(withIdentifier: NSStringFromClass(MessagesCell.self), for: indexPath) as! MessagesCell
        cell.update(with: message)
        return cell
    }
    
    
    // Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectSelectedRow()
        guard let message = table_data[safe: indexPath.row] else {
            return
        }
        
        let conversation_controller = ConversationController(nibName: nil, bundle: nil)
        conversation_controller.listing = message.listing
        self.navigationController?.pushViewController(conversation_controller, animated: true)
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if Utils.isHamburgerOpen(revealer: self.revealViewController()) {
            return
        }
    }
    */
    
    
}



