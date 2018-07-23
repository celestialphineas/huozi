//
//  FAButton.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/23.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

@IBDesignable
class FAButton: UIButton {
    
    @IBInspectable var buttonColor: UIColor! = UIColor.black
    @IBInspectable var imageScale: CGFloat = 0.8

    override func draw(_ rect: CGRect) {
        // Do not clip the button to bounds
        clipsToBounds = false
        
        // Draw the circle
        let circlePath = UIBezierPath(ovalIn: rect)
        buttonColor.setFill()
        circlePath.fill()
        
        // Adjust image
        
        imageView?.contentMode = .scaleAspectFill
    }

}
