//
//  CharacterDetailCard.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/30.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable
class CharacterDetailCard: UIView, DropsShadow {
    
    @IBOutlet var characterDetailCard: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var characterAndPinyin: UILabel!
    @IBOutlet weak var characterDefinition: UILabel!
    
    private func initialize() {
        Bundle.main.loadNibNamed("CharacterDetailCard", owner: self, options: nil)
        addSubview(characterDetailCard)
        characterDetailCard.frame = self.bounds
        characterDetailCard.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // Setting corner radius of the card
        self.cornerRadius(20)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func draw(_ rect: CGRect) {
        drawShadow()
        container.layer.cornerRadius = cornerRadius
        container.clipsToBounds = true
    }
    
    @IBAction func speek() {
        if let characterToSpeak = characterAndPinyin.text?.first,
            let definitionToSpeak = characterDefinition.text {
            let toSpeak = "\(characterToSpeak)。\(definitionToSpeak)"
            let utter = AVSpeechUtterance(string: toSpeak)
            let synth = AVSpeechSynthesizer()
            synth.speak(utter)
        }
    }
}
