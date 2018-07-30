//
//  AchievementAccomplishedPresentView.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/30.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

class ShadowView: UIView, DropsShadow {}

class AchievementViewController: UIViewController {
 
    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var achievementImage: UIImageView!
    
    var storyData: StoryData!
    
    override func viewDidLoad() {
        shadowView.cornerRadius(20)
        shadowView.drawShadow()
        shadowView.shadowRadius(2)
        shadowView.shadowOpacity(0.2)
        container.layer.cornerRadius = shadowView.cornerRadius
        
        if storyData != nil {
            titleLabel.text = storyData.medalDescription
            achievementImage.image = UIImage(named: storyData.imageName)
        }
    }
    
    @IBAction func tellStory() {
        if let contextController = presentingViewController as? StoryHomeViewController {
            let id = contextController.toTellingSegueIdentifier
            self.dismiss(animated: true) {
                contextController.performSegue(withIdentifier: id, sender: contextController)
            }
        }
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
