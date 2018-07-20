//
//  HomeTableViewController.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/18.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

@IBDesignable
class HomeTableViewController: UITableViewController {
    let cellHeight  : CGFloat = 200
    let headerHeight: CGFloat = 64
    let footerHeight: CGFloat = 40
    
    // Cell setting
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: StoryCardCell = tableView.dequeueReusableCell(withIdentifier: "StoryCardCell", for: indexPath) as! StoryCardCell
        
        // Setting data for the cell
        let data = DataHandler.data[indexPath.item]
        if data["img"]  is String { cell.backgroundImageName = data["img"] as! String }
        if data["name"] is String { cell.title = data["name"] as! String }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Cell count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataHandler.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 64))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }
}
