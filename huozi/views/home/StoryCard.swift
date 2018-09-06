//
//  StoryCard.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/20.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit
import Hero

class StoryCard: UIView, DropsShadow {

    @IBOutlet var storyCard: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelOnMask: UILabel!
    @IBOutlet weak var checkedImage: UIImageView!
    @IBOutlet weak var lockedView: UIVisualEffectView!
    
    private var lockedVal = false
    var locked: Bool {
        get { return lockedVal }
        set {
            lockedVal = newValue
            titleLabelOnMask.text = titleLabel.text
            if lockedVal { lockedView.isHidden = false }
            else { lockedView.isHidden = true }
        }
    }
    
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
        Bundle.main.loadNibNamed("StoryCard", owner: self, options: nil)
        addSubview(storyCard)
        storyCard.frame = self.bounds
        storyCard.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        checkedImage.tintColor = UIColor(red: 253.0/255.0, green: 1.0, blue: 147.0/255.0, alpha: 1.0)
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
        titleLabelOnMask.text = titleLabel.text
    }
}
