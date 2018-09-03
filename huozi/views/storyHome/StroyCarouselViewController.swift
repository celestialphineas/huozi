//
//  StoryCarouselViewController.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/23.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

class StoryCarouselViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    @IBOutlet var carouselView: iCarousel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // This is the identifier of the segue to the next scene
    let piecingSegueIdentifier = "storyHomeToPiecing"
    let tellingStorySegueIdentifier = "storyHomeToTelling"
    
    // A list of characters to learn
    var characters: [String]!
    
    // Previous selected item among the cards
    // We need this to control the data
    private weak var previousItem: AnimationCard!
    
    override func viewDidLoad() {
        // Initializing the page control
        if carouselView != nil {
            carouselView.type = .rotary
            if pageControl != nil {
                pageControl.numberOfPages = numberOfItems(in: carouselView)
            }
        }
        // Force carousel view to page
        carouselView.isPagingEnabled = true
    }
    
    // Handling segue
    private var fromUpperScene = true
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // For better performance, stop animation before performing segue
        if let animationCard = carouselView.currentItemView as? AnimationCard,
        let animationView = animationCard.animationView {
            animationView.stopAnimation()
        }
        
        fromUpperScene = ![piecingSegueIdentifier, tellingStorySegueIdentifier].contains(segue.identifier)
        
        if segue.identifier == piecingSegueIdentifier,
        let destination = segue.destination as? PiecingCharacterViewController {
            if let currentView = carouselView.currentItemView as? AnimationCard {
                destination.characterToDisplay = currentView.characterToDisplay
            }
        }
    }
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        performSegue(withIdentifier: piecingSegueIdentifier, sender: self)
    }
    
    // This is the entering animation for carousel items
    func enteringAnimation() {
        for view in self.carouselView.subviews {
            if view as? UIPageControl == nil {
                for view in view.subviews {
                    let oldAlpha = view.alpha
                    view.alpha = 0
                    UIView.animate(withDuration: 1 - Double(oldAlpha) * 0.8) {
                        view.alpha = oldAlpha
                    }
                }
            }
        }
    }
    
    // This function allows the cards to animate when entering!
    override func viewDidAppear(_ animated: Bool) {
        // For better performance, continue animation
        if let animationCard = carouselView.currentItemView as? AnimationCard,
            let animationView = animationCard.animationView {
            animationView.startAnimation()
        }
        
        // Decide whether showing the entering animation or not
        if fromUpperScene {
            enteringAnimation()
        }
        
        // Setting the first animation card to play
        if let animationCard = carouselView.itemView(at: 0) as? AnimationCard {
            animationCard.playAnimation()
            previousItem = animationCard
        }
        
        // Character checks
        for index in 0...characters.count {
            if let animationCard = carouselView.itemView(at: index) as? AnimationCard {
                if UserProgressModel.characterDone(book: UserState.currentBook.index, story: UserState.currentStory.index, character: characters[index]) {
                    animationCard.checked = true
                }
            }
        }
        
    }
    
    // Update index of the item
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if pageControl != nil {
            pageControl.currentPage = carousel.currentItemIndex
        }
        
        // Let the current animation to play, and disable the animations that are invisible
        if let animationCard = carousel.itemView(at: carousel.currentItemIndex) as? AnimationCard {
            if previousItem != nil {
                previousItem.stopAnimation()
            }
            animationCard.playAnimation()
            previousItem = animationCard
        }
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return characters != nil ? characters.count : 0
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let animationCard = AnimationCard(frame: AnimationCard.expectedFrame)
        animationCard.isOpaque = false
        let characterData = CharacterData(characters[index])
        characterData.index = index
        animationCard.characterToDisplay = characterData
        
        return animationCard
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .spacing   : return value * 0.2
        case .fadeMin   : return 0
        case .fadeMax   : return 0
        case .fadeRange : return 4
        default         : return value
        }
    }
}
