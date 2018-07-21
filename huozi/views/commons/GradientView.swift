//
//  GradientView.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/20.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit
import Foundation

// This view simply draws gradient
@IBDesignable
class GradientView: UIView {
    @IBInspectable var cornerRadius     : CGFloat = 0
    @IBInspectable var color1   : UIColor = UIColor.white
    @IBInspectable var color2   : UIColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0)
    
    override func draw(_ rect: CGRect) {
        let ctx         = UIGraphicsGetCurrentContext()!
        let colors      = [color1.cgColor, color2.cgColor]
        let colorSpace  = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0, 1]
        let gradient    = CGGradient(colorsSpace    : colorSpace,
                                     colors         : colors as CFArray,
                                     locations      : colorLocations)!
        let startPoint  = CGPoint.zero
        let endPoint    = CGPoint(x: 0, y: bounds.height)
        self.layer.cornerRadius   = cornerRadius
        ctx.drawLinearGradient(gradient,
                               start: startPoint,
                               end: endPoint,
                               options: [])
    }
}
