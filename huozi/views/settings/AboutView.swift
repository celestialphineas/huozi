//
//  AboutView.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/9/4.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit
import Hero

class AboutViewController: UIViewController {
    @IBOutlet weak var versionNumber: UILabel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    func initialize() {
        hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .pull(direction: .right))
    }
    override func viewWillAppear(_ animated: Bool) {
        let versionString = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
        versionNumber.text = "版本号：\(versionString)"
    }
    @IBAction func dismiss() {
        dismiss(animated: true) {}
    }
}
