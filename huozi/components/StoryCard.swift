//
//  StoryCard.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/18.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

@IBDesignable
class StoryCard: UIView {
    @IBInspectable var cornerRadius     : CGFloat = 5
    @IBInspectable var shadowOpacity    : Float   = 0.3
    @IBInspectable var shadowRadius     : CGFloat = 5
    @IBInspectable var shadowOffsetX    : CGFloat = 1
    @IBInspectable var shadowOffsetY    : CGFloat = 1
    
    private func addCardShadow() {
        // Add shadow to the base view
        self.layer.masksToBounds    = false
        self.layer.shadowOpacity    = shadowOpacity
        self.layer.shadowRadius     = shadowRadius
        self.layer.shadowOffset     = CGSize(width: shadowOffsetX, height: shadowOffsetY)
        
        // Improve performance
        self.layer.shadowPath       = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.shouldRasterize  = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        // Add background to subview
        let bgView = UIView()
        bgView.backgroundColor      = UIColor.white
        bgView.frame                = self.bounds
        bgView.layer.cornerRadius   = cornerRadius
        bgView.layer.masksToBounds  = true
        
        // Add subview to base view
        self.addSubview(bgView)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addCardShadow()
    }
}
