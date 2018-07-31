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
    @IBOutlet weak var checkedImage: UIImageView!
    
    private var checkedVal = false
    var checked: Bool {
        get { return checkedVal }
        set {
            checkedVal = newValue
            if checked { checkedImage.alpha = 1 }
            else { checkedImage.alpha = 0 }
        }
    }
    
    private func initialize() {
        Bundle.main.loadNibNamed("AnimationCard", owner: self, options: nil)
        addSubview(animationCard)
        animationCard.frame = self.bounds
        animationCard.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // Setting corner radius of the card
        self.cornerRadius(20)
        
        // checkedImage
        checkedImage.tintColor = UIColor(red: 38.0/255.0, green: 195.0/255.0, blue: 44.0/255.0, alpha: 1)
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
            let prefix = GlobalViewModel.animationPathPrefix
            let animationPath = prefix + animationName
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
