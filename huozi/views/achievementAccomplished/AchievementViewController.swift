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
    
    func beforeImageAnimation() {
        achievementImage.alpha = 0
        achievementImage.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }
    
    override func viewDidLoad() {
        shadowView.cornerRadius(20)
        shadowView.shadowRadius(100)
        shadowView.shadowOpacity(0.1)
        shadowView.drawShadow()
        container.layer.cornerRadius = shadowView.cornerRadius
        
        if storyData != nil {
            titleLabel.text = storyData.medalDescription
            achievementImage.image = UIImage(named: storyData.medalImageName)
        }
        beforeImageAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        beforeImageAnimation()
        UIView.animate(
            withDuration: 2,
            delay: 0,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                self.achievementImage.alpha = 1
                self.achievementImage.transform = .identity
            },
            completion: nil
        )
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
