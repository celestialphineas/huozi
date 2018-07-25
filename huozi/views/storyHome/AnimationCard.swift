//
//  AnimationCard.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/23.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

// This file is connected to the animation card view .xib file

import UIKit

class AnimationCard: UIView, DropsShadow {

    static var expectedFrame: CGRect { get { return CGRect(x: 0, y: 0, width: 240, height: 360) } }
    
    // This variable is the current character to learn
    var characterToDisplay: CharacterData!
    
    @IBOutlet var animationCard: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var animationView: SVGAImageView!
    
    // Bundle path prefix
    @IBInspectable var animationPathPrefix = "res/animations/"
    
    private func initialize() {
        Bundle.main.loadNibNamed("AnimationCard", owner: self, options: nil)
        addSubview(animationCard)
        animationCard.frame = self.bounds
        animationCard.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // Setting corner radius of the card
        self.cornerRadius(20)
        
        animationView.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func draw(_ rect: CGRect) {
        drawShadow()
        container.layer.cornerRadius = cornerRadius
        container.clipsToBounds = true
        if let animationName = characterToDisplay.animationName {
            let animationPath = animationPathPrefix + animationName
            if Bundle.main.path(forResource: animationPath, ofType: "svga") != nil {
                animationView.imageName = animationPath
            }
        }
        super.draw(rect)
    }
    
    func playAnimation() {
        animationView?.startAnimation()
    }
    
    func stopAnimation() {
        animationView?.stopAnimation()
    }
}
