//
//  StoryCardCell.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/18.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

@IBDesignable
class StoryCardCell: UITableViewCell {
    override func draw(_ rect: CGRect) {
        self.layer.masksToBounds = false
        super.draw(rect)
    }
}
