//
//  StoryCard.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/20.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit
import Hero

@IBDesignable
class StoryCard: UIView, DropsShadow {

    @IBOutlet var storyCard: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private func initialize() {
        Bundle.main.loadNibNamed("StoryCard", owner: self, options: nil)
        addSubview(storyCard)
        storyCard.frame = self.bounds
        storyCard.autoresizingMask = [.flexibleHeight, .flexibleWidth]
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
