//
//  StoryCard.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/18.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

class StoryCard: UIView {
    @IBInspectable var cornerRadius     : CGFloat = 5
    @IBInspectable var shadowOpacity    : Float   = 0.3
    @IBInspectable var shadowRadius     : CGFloat = 5
    @IBInspectable var shadowOffsetX    : CGFloat = 1
    @IBInspectable var shadowOffsetY    : CGFloat = 1
    @IBOutlet weak var nameLabel        : UILabel!
    
    private func drawShadow() {
        // Add shadow to the base view
        self.layer.masksToBounds    = false
        self.layer.shadowOpacity    = shadowOpacity
        self.layer.shadowRadius     = shadowRadius
        self.layer.shadowOffset     = CGSize(width: shadowOffsetX, height: shadowOffsetY)
        
        // Improve performance
        self.layer.shadowPath       = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.shouldRasterize  = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func drawBackground(_ containable: StoryCardContainable? = nil) {
        var bgImgName = "default"
        if containable != nil {
            bgImgName = containable!.backgroundImageName
        }
        let uiImage = UIImage(imageLiteralResourceName: bgImgName)
        
        // Fit the aspect
        var rectArgs = (x: 0 as CGFloat, y: 0 as CGFloat, width: frame.size.width as CGFloat, height: frame.size.height as CGFloat)
        let imageAspect = uiImage.size.width/uiImage.size.height
        if imageAspect * rectArgs.height < rectArgs.width {
            let oldHeight = rectArgs.height
            rectArgs.height = rectArgs.width / imageAspect
            rectArgs.y = (oldHeight - rectArgs.height)/2
        } else {
            let oldWidth = rectArgs.width
            rectArgs.width = rectArgs.height * imageAspect
            rectArgs.x = (oldWidth - rectArgs.width)/2
        }
        let fillRect = CGRect(x: rectArgs.x, y: rectArgs.y, width: rectArgs.width, height: rectArgs.height)
        UIGraphicsBeginImageContext(fillRect.size)
        uiImage.draw(in: fillRect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Add background to subview
        let bgView = UIView()
        bgView.backgroundColor      = UIColor(patternImage: image)
        bgView.frame                = self.bounds
        bgView.layer.cornerRadius   = cornerRadius
        bgView.layer.masksToBounds  = true
        self.insertSubview(bgView, at: 0)
    }
    
    private func handleOutlets(_ containable: StoryCardContainable? = nil) {
        if containable != nil {
            nameLabel.text = containable!.title
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawShadow()
        
        let supsupView = superview?.superview
        var containable: StoryCardContainable? = nil
        if supsupView is StoryCardContainable { containable = supsupView as! StoryCardContainable? }
        drawBackground(containable)
        handleOutlets(containable)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
        }) { (_) in UIView.animate(withDuration: 0.25) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
}
