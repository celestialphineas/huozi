//
//  HomeViewController.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/9/1.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit
import SideMenuSwift

class HomeViewController: DesignableViewController {
    @IBOutlet weak var homeTableViewContainer: UIView!
    let homeTableSegue = "homeTableSegue"
    var homeTableController: HomeTableViewController! = nil
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == homeTableSegue {
            homeTableController = segue.destination as! HomeTableViewController
        }
    }
    
    @IBAction func revealMenu() {
        self.sideMenuController?.revealMenu()
        // Pass the home table view controller to the menu
        if let menuController = self.sideMenuController?.menuViewController as? SideMenuViewController {
            if let tableController = menuController.sideMenuTableController {
                tableController.homeTableViewController = homeTableController
            }
        }
    }
}
