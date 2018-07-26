//
//  componentView.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/26.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

@IBDesignable
class CharacterComponentView: UIView, DropsShadow {
    
    @IBInspectable var cornerRadius: CGFloat = 10
    
    var containerView:      UIView!
    var componentImage:     UIImageView!
    var componentToDisplay: CharacterData.Component!
    
    private func initialize() {
        // Initialize a component image view
        componentImage = UIImageView(frame: self.bounds)
        componentImage.image = UIImage(named: "placeholder")
        
        // Set up the containerView of the object
        containerView = UIView(frame: self.bounds)
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = cornerRadius
        
        // Corner radius of the card
        cornerRadius(cornerRadius)
        
        // Insert the views
        addSubview(containerView)
        containerView.addSubview(componentImage)
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
        initialize()
        componentToDisplay = component
    }

    override func draw(_ rect: CGRect) {
        // Make a change to the component image
        if let imageName = componentToDisplay?.imageName {
            componentImage.image = UIImage(named: imageName)
        }
        drawShadow()
    }
}
