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
    var visualEffectView:   UIVisualEffectView!
    var componentToDisplay: CharacterData.Component!
    var center0: CGPoint!
    var frame0: CGRect!
    
    var pieceDone = false
    
    // A pointer to the character box view
    var characterBox: CharacterBoxView!
    
    let imageTint = UIColor.black
    
    // True if I am the correct answer
    var bingo: Bool {
        get {
            if characterBox != nil { return characterBox.has(componentToDisplay.name) }
            return false
        }
    }
    
    private func initialize() {
        let x = bounds.minX, y = bounds.minY, w = bounds.height, h = bounds.height
        let aspectBound = CGRect(x: x, y: y, width: w, height: h)
        
        // Initialize a component image view
        componentImage = UIImageView(frame: aspectBound)
        componentImage.image = UIImage(named: "placeholder")
        // Initialize the visual effect view
        visualEffectView = UIVisualEffectView(frame: aspectBound)
        
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
        containerView.addSubview(visualEffectView)
        
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
    
    init(_ component: CharacterData.Component, _ box: CharacterBoxView, frame: CGRect) {
        super.init(frame: frame)
        componentToDisplay = component
        characterBox = box
        initialize()
    }
    
    // Touch behaviors of the components
    // Here are a series of affine transformations
    private class Transformation {
        static let onTouchFactor    : CGFloat = 1.6
        static let onTouchBoxFactor : CGFloat = 2.5
        static var onTouchZoomIn    = CGAffineTransform(scaleX: onTouchFactor, y: onTouchFactor)
        static var onTouchBox       = CGAffineTransform(scaleX: onTouchBoxFactor, y: onTouchBoxFactor)
    }
    
    // --------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if pieceDone { return }
        center0 = center
        frame0 = frame
        UIView.animate(withDuration: 0.25) {
            self.transform = Transformation.onTouchZoomIn
        }
        superview?.bringSubview(toFront: self)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if pieceDone { return }
        if let touch = touches.first {
            center.x += touch.location(in: self).x - frame0.width/2
            center.y += touch.location(in: self).y - frame0.height/2
        }
        if touchingBox {
            // This line cannot be omitted, for touchedBox has a setter
            if !touchedBox { touchedBox = true }
        } else {
            // This line cannot be omitted, for touchedBox has a setter
            if touchedBox { touchedBox = false }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if pieceDone { return }
        if bingo && touchingBox {
            doPieced()
        } else {
            UIView.animate(withDuration: 0.25) {
                self.center = self.center0
                self.transform = .identity
            }
        }
    }
    
    // Test if the component is touching the character box
    private var touchingBox:Bool {
        get {
            if characterBox != nil {
                let boxTouchedRadius = characterBox.frame.height
                if let selfFrame = superview?.convert(frame, to: nil),
                    let boxFrame = characterBox.superview?.convert(characterBox.frame, to: nil) {
                    let distance = abs(selfFrame.midX - boxFrame.midX) + abs(selfFrame.midY - boxFrame.midY)
                    if distance < boxTouchedRadius { return true }
                }
                return false
            } else { return false }
        }
    }
    
    private var touchedBoxVal = false
    private var touchedBox: Bool {
        get {
            return touchedBoxVal
        }
        set {
            touchedBoxVal = newValue
            if touchedBox {
                // Bingo?
                if bingo { doBingo() }
                // UI animation
                UIView.animate(withDuration: 0.4) { self.transform = Transformation.onTouchBox }
            } else {
                // Bingo?
                if bingo { doReverseBingo() }
                // UI animation
                UIView.animate(withDuration: 0.2) { self.transform = Transformation.onTouchZoomIn }
            }
        }
    }
    // Do this when bingo!
    private func doBingo() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0.2
            self.visualEffectView.effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        }
        characterBox.showTemporarily(componentToDisplay.name)
    }
    // Do this when bingo but the user did not choose to select
    private func doReverseBingo() {
        UIView.animate(withDuration: 0.15) { self.alpha = 1.0 }
        characterBox.hide(componentToDisplay.name)
        self.visualEffectView.effect = nil
    }
    // Do this when piece done!
    private func doPieced() {
        UIView.animate(withDuration: 0.10) {
            self.center = self.center0
            self.transform = .identity
        }
        UIView.animate(withDuration: 0.8) {
            self.alpha  = 0.3
            self.visualEffectView.effect = nil
        }
        characterBox.show(componentToDisplay.name)
        pieceDone = true
    }
}
