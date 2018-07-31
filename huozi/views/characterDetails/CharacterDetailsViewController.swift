//
//  CharacterDetailsViewController.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/29.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

class CharacterDetailsViewController: DesignableViewController {
    
    var characterToDisplay: CharacterData!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var animationView: SVGAImageView!
    @IBOutlet weak var characterBox: CharacterBoxView!
    @IBOutlet weak var characterDetailCard: CharacterDetailCard!
    
    override func viewDidLoad() {
        // Background image
        backgroundImage.image = GlobalViewModel.currentBackground
        
        // Animation
        if let animationName = characterToDisplay.animationName {
            let prefix = GlobalViewModel.animationPathPrefix
            let animationPath = prefix + animationName
            if Bundle.main.path(forResource: animationPath, ofType: "svga") != nil {
                animationView.imageName = animationPath
            }
        }
        
        // Character box
        characterBox.characterComposition = characterToDisplay.components
        for (_, component) in characterBox.componentImageViews {
            component.alpha = 1.0
        }
        
        // Card data
        characterDetailCard.characterAndPinyin.text = "\(characterToDisplay.name)  \(characterToDisplay.pinyin)"
        characterDetailCard.characterDefinition.text = characterToDisplay.definition
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwind() {
        performSegue(withIdentifier: "unwindCharacterDetails", sender: self)
    }
}
