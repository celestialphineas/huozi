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
    let containerSegueIdentifier = "storyHomeContainerSegue"
    
    var storyData: StoryData!
    var heroIndex: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = storyData.title
        titleLabel.hero.id = "title-\(heroIndex)"
        GlobalViewModel.currentBackground = UIImage(named: storyData.imageName)
        backgroundImage.image = GlobalViewModel.currentBackground
        backgroundImage.hero.id = "img-\(heroIndex)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == containerSegueIdentifier {
            if let storyCarouselViewController = segue.destination as? StoryCarouselViewController {
               storyCarouselViewController.characterData = storyData.characters
            }
        }
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
