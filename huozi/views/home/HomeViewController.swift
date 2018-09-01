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
    @IBAction func revealMenu() {
        self.sideMenuController?.revealMenu();
    }
}
