//
//  courseHomeView.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/21.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

class CourseHomeViewController: UIViewController {
    @IBOutlet weak var testlabel: UILabel!
    
    var storyData: StoryData!
    
    override func viewWillAppear(_ animated: Bool) {
        if storyData != nil {
            testlabel.text = storyData.plain
        }
    }
}
