//
//  PiecingCharacterViewController.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/26.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

class PiecingCharacterViewController: UIViewController {
    
    var characterToDisplay: CharacterData!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var animationView: SVGAImageView!
    @IBOutlet weak var candidateStackView: UIStackView!
    @IBOutlet weak var characterBox: CharacterBoxView!
    
    
    override func viewDidLoad() {
        // Background image
        backgroundImage.image = GlobalViewModel.currentBackground
        if let animationName = characterToDisplay.animationName {
            let prefix = GlobalViewModel.animationPathPrefix
            let animationPath = prefix + animationName
            if Bundle.main.path(forResource: animationPath, ofType: "svga") != nil {
                animationView.imageName = animationPath
            }
        }
        
        // Initialize component candidate views in the stack
        let height = candidateStackView.frame.height
        if let candidates = characterToDisplay?.candidates {
            for candidate in candidates {
                if candidateStackView != nil {
                    let view = CharacterComponentView(candidate, frame: CGRect(x: 0, y: 0, width: height, height: height))
                    candidateStackView.addArrangedSubview(view)
                }
            }
        }
        
        // Pass the character composition data to the character box
        if characterBox != nil {
            characterBox.characterComposition = characterToDisplay.components
        }
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
