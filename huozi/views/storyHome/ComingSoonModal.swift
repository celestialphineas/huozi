//
//  ComingSoonModal.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/9/7.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

class ComingSoonModal: UIViewController {
    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        shadowView.cornerRadius(20)
        shadowView.shadowRadius(100)
        shadowView.shadowOpacity(0.1)
        shadowView.drawShadow()
        container.layer.cornerRadius = shadowView.cornerRadius
    }
    override func viewWillAppear(_ animated: Bool) {
        if animated {
            shadowView.alpha = 0
            shadowView.transform = CGAffineTransform(scaleX: 1.3, y: 1.2).translatedBy(x: 0, y: -20)
            UIView.animate(withDuration: 0.25) {
                self.shadowView.alpha = 1
                self.shadowView.transform = CGAffineTransform.identity
            }
        }
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
}
