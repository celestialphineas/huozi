//
//  StoryhomeView.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/21.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

class StoryHomeViewController: DesignableViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tellingStoryButton: IconButton!
    let containerSegueIdentifier = "storyHomeContainerSegue"
    let presentSegueIdentifier = "storyHomeToPresent"
    let toTellingSegueIdentifier = "storyHomeToTelling"
    
    var storyData: StoryData!
    var heroIndex: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = storyData.title
        titleLabel.hero.id = "title-\(heroIndex)"
        GlobalViewModel.currentBackground = UIImage(named: storyData.imageName)
        backgroundImage.image = GlobalViewModel.currentBackground
        backgroundImage.hero.id = "img-\(heroIndex)"
        
        // Story done?
        let book = UserState.currentBook.index!
        let story = UserState.currentStory.index!
        if UserProgressModel.allCharactersDone(book: book, story: story) {
            tellingStoryButton.isEnabled = true
            tellingStoryButton.alpha = 1
        } else {
            tellingStoryButton.isEnabled = false
            tellingStoryButton.alpha = 0
        }
        // Should get medal?
        if UserProgressModel.allCharactersDone(book: book, story: story)
            && !UserProgressModel.hasStoryMedal(book: book, story: story) {
                performSegue(withIdentifier: presentSegueIdentifier, sender: self)
                UserProgressModel.addMedal(book: book, story: story)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            case containerSegueIdentifier:
                if let storyCarouselViewController = segue.destination as? StoryCarouselViewController {
                    storyCarouselViewController.characters = storyData.characters
                }
            case toTellingSegueIdentifier:
                if let tellingStoryViewController = segue.destination as? TellingStoryViewController {
                    tellingStoryViewController.storyData = storyData
                }
            case presentSegueIdentifier:
                if let achievementViewController = segue.destination as? AchievementViewController {
                    achievementViewController.storyData = storyData
                }
            default:
                return
        }
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindAction(segue: UIStoryboardSegue) {}
}
