//
//  DesignableViewController.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/22.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableViewController: UIViewController {
    
    @IBInspectable var LightStatusBar: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            if LightStatusBar {
                return UIStatusBarStyle.lightContent
            } else {
                return UIStatusBarStyle.default
            }
        }
    }
}
