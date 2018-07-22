//
//  courseHomeView.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/21.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

class CourseHomeViewController: DesignableViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var storyData: StoryData!
    var heroIndex: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = storyData.title
        titleLabel.hero.id = "title-\(heroIndex)"
        backgroundImage.image = storyData.cardImage
        backgroundImage.hero.id = "img-\(heroIndex)"
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
