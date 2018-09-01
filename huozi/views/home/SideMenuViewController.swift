//
//  SideMenuViewController.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/9/1.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
}

class SideMenuContainerController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
}

class SideMenuTableController: UITableViewController {
    var books = Books()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTableCell", for: indexPath) as! SideMenuTableCell
        cell.label.text = books.data[indexPath.item].name
        return cell
    }
}

class SideMenuTableCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
}
