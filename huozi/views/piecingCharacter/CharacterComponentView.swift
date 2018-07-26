//
//  componentView.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/26.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

@IBDesignable
class CharacterComponentView: UIButton, DropsShadow {
    
    @IBInspectable var cornerRadius: CGFloat = 10
    
    var containerView:      UIView!
    var componentImage:     UIImageView!
    var componentToDisplay: CharacterData.Component!
    var center0: CGPoint!
    
    let imageTint = UIColor.black
    let onTouchScaleFactor: CGFloat = 1.6
    
    private func initialize() {
        let x = bounds.minX, y = bounds.minY, w = bounds.height, h = bounds.height
        let aspectBound = CGRect(x: x, y: y, width: w, height: h)
        
        // Initialize a component image view
        componentImage = UIImageView(frame: aspectBound)
        componentImage.image = UIImage(named: "placeholder")
        
        // Set up the containerView of the object
        containerView = UIView(frame: aspectBound)
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = cornerRadius
        
        // Corner radius of the card
        cornerRadius(cornerRadius)
        
        // Insert the views
        addSubview(containerView)
        containerView.addSubview(componentImage)
        
        // Make a change to the component image
        if let imageName = componentToDisplay?.imageName,
           let image = UIImage(named: imageName) {
            componentImage.image = image
            componentImage.tintColor = imageTint
        }
        drawShadow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    init(_ component: CharacterData.Component, frame: CGRect) {
        super.init(frame: frame)
        componentToDisplay = component
        initialize()
    }
    
    // Touch behaviors of the components
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        center0 = center
        UIView.animate(withDuration: 0.25) {
            self.transform
                = CGAffineTransform(scaleX: self.onTouchScaleFactor, y: self.onTouchScaleFactor)
        }
        superview?.bringSubview(toFront: self)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            center.x += touch.location(in: self).x - frame.width/2/onTouchScaleFactor
            center.y += touch.location(in: self).y - frame.height/2/onTouchScaleFactor
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.25) {
            self.center = self.center0
            self.transform = CGAffineTransform.identity
        }
    }
}
