//
//  CharacterBoxView.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/26.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

@IBDesignable
class CharacterBoxView: UIView {
    
    @IBInspectable var imageTint: UIColor = UIColor(red: 1.0, green: 0.25, blue: 0.5, alpha: 1.0)
    
    private var characterCompositionVal: [CharacterData.Component]!
    var characterComposition: [CharacterData.Component]! {
        get { return characterCompositionVal }
        set {
            characterCompositionVal = newValue
            initialize()
        }
    }
    var latestQuery: CharacterData.Component! = nil
    var componentImageViews: [String: UIImageView] = [:]
    
    private func initialize() {
        // It is promised that characterComposition is set
        // Generate UIImageViews for character compositions
        for component in characterComposition {
            let componentImageView = UIImageView(frame: bounds)
            componentImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            // Image view settings
            componentImageView.contentMode = .scaleToFill
            componentImageView.tintColor = imageTint
            // Image
            if let componentImage = UIImage(named: component.imageName) {
                componentImageView.image = componentImage
            } else {
                print("Unable to load image \(component.imageName)")
            }
            // Add the view to the superview
            componentImageViews[component.name] = componentImageView
            addSubview(componentImageView)
            // Hide the component image
            componentImageView.alpha = 0
        }
    }
    
    // This function tests whether some component is in the character composition
    func has(_ someComponent: String) -> Bool {
        if characterComposition != nil {
            for component in characterComposition {
                if component.name == someComponent {
                    latestQuery = component
                    return true
                }
            }
        }
        return false
    }
    
    func showAnimation(alpha: CGFloat, in duration: TimeInterval) -> ((String) -> Void) {
        return { (someComponent: String) in
            if let componentImageView = self.componentImageViews[someComponent] {
                UIView.animate(withDuration: duration) {
                    componentImageView.alpha = alpha
                }
            }
        }
    }
    func showTemporarily(_ someComponent: String) { showAnimation(alpha: 0.5, in: 0.3)(someComponent) }
    func show(_ someComponent: String) { showAnimation(alpha: 1, in: 0.3)(someComponent) }
    func hide(_ someComponent: String) { showAnimation(alpha: 0, in: 0.5)(someComponent) }
}
