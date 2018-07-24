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
    
    @IBOutlet var animationCard: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var animationView: SVGAImageView!
    
    private func initialize() {
        Bundle.main.loadNibNamed("AnimationCard", owner: self, options: nil)
        addSubview(animationCard)
        animationCard.frame = self.bounds
        animationCard.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // Setting corner radius of the card
        self.cornerRadius(20)
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
        super.draw(rect)
        drawShadow()
        container.layer.cornerRadius = cornerRadius
        container.clipsToBounds = true
    }
}
