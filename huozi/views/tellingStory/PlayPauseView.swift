//
//  PlayPauseButton.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/30.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

@IBDesignable
class PlayPauseView: UIView, DropsShadow {
    
    @IBOutlet var playPauseView: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var animationView: SVGAImageView!
    
    private func initialize() {
        Bundle.main.loadNibNamed("PlayPauseView", owner: self, options: nil)
        addSubview(playPauseView)
        playPauseView.frame = self.bounds
        playPauseView.autoresizingMask = [.flexibleHeight, .flexibleHeight]
        
        // Setting corner radius
        let (w, h) = (bounds.width, bounds.height)
        self.cornerRadius(min(w, h)/2)
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
        animationView.step(toPercentage: 1, andPlay: false)
    }
    
    private var playing = false
    func toggleToPlay() {
        let numberOfFrames = Int(animationView.videoItem.frames)
        if !playing {
            animationView.startAnimation(with: NSRange(location: 0, length: numberOfFrames), reverse: true)
        }
        playing = true
    }
    
    func toggleToPause() {
        let numberOfFrames = Int(animationView.videoItem.frames)
        if playing {
            animationView.startAnimation(with: NSRange(location: 0, length: numberOfFrames), reverse: false)
        }
        playing = false
    }
}
