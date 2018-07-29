//
//  PiecingCharacterViewController.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/26.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

class PiecingCharacterViewController: DesignableViewController, PiecingProgressDelegate {
    
    var characterToDisplay: CharacterData!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var animationView: SVGAImageView!
    @IBOutlet weak var candidateStackView: UIStackView!
    @IBOutlet weak var characterBox: CharacterBoxView!
    
    // Perform segue when piecing finished
    let detailsSegueIdentifier = "piecingToDetails"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailsSegueIdentifier {
            if let destination = segue.destination as? CharacterDetailsViewController {
                destination.characterToDisplay = characterToDisplay
            }
        }
    }
    func donePiecing() {
        performSegue(withIdentifier: detailsSegueIdentifier, sender: self)
    }
    
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
                    let view = CharacterComponentView(candidate, characterBox, frame: CGRect(x: 0, y: 0, width: height, height: height))
                    candidateStackView.addArrangedSubview(view)
                }
            }
        }
        
        // Pass the character composition data to the character box
        if characterBox != nil {
            characterBox.characterComposition = characterToDisplay.components
        }
        
        // Passing delegate
        characterBox.piecingProgressDelegates.append(self)
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
