//
//  tellingStoryViewController.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/29.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

class TellingStoryViewController: DesignableViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var scrollingLyricsView: ScrollingLyricsView!
    @IBOutlet weak var playPauseView: PlayPauseView!
    
    var storyData: StoryData!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = storyData.title
        backgroundImage.image = GlobalViewModel.currentBackground
        scrollingLyricsView.lyrics = storyData.bySentence
        scrollingLyricsView.playPauseView = playPauseView
    }
    
    @IBAction func dismiss() {
        // Stop the story telling
        scrollingLyricsView.stop()
        // Dismiss view
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggle() {
        if scrollingLyricsView.nowPlaying { scrollingLyricsView.pause() }
        else { scrollingLyricsView.play() }
    }
}
