
//
//  IconButton.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/22.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

class IconButton: UIButton {
    @IBInspectable var touchZoomingScale: CGFloat = 1.2
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(scaleX: self.touchZoomingScale, y: self.touchZoomingScale)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity
        }
    }
}
