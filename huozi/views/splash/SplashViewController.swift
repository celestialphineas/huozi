//
//  SplashViewController.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/31.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

class SplashViewController: DesignableViewController {
    @IBOutlet weak var splashIcon: UIImageView!
    
    let toHomeSegueIdentifier = "splashToHome"
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(
        withDuration: 0.25,
        delay: 0.2,
        options: [.curveEaseOut],
        animations: {
            self.splashIcon.transform = CGAffineTransform(translationX: 0, y: -60)
        }) { _ in UIView.animate(
            withDuration: 0.8,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                self.splashIcon.transform = .identity
        }) { _ in self.performSegue(withIdentifier: self.toHomeSegueIdentifier, sender: self)}}
    }
}
