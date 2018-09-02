//
//  SideMenuViewController.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/9/1.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    @IBOutlet weak var sideMenuContainer: UIView!
    let sideMenuTableSegue = "sideMenuTableSegue"
    var sideMenuTableController: SideMenuTableController! = nil
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == sideMenuTableSegue {
            sideMenuTableController = segue.destination as! SideMenuTableController
        }
    }
}

class SideMenuTableController: UITableViewController {
    var books = Books()
    weak var homeTableViewController: HomeTableViewController?
    
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserState.currentBook = books.data[indexPath.item]
        homeTableViewController?.updateDataHandler()
        sideMenuController?.hideMenu()
    }
}

class SideMenuTableCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
}
