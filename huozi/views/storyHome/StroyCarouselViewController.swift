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
    
    // A list of characters to learn
    var characterData: [String]!
    
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
    
    // This function allows the cards to animate when entering!
    override func viewDidAppear(_ animated: Bool) {
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
        
        // Setting the first animation card to play
        if let animationCard = carouselView.itemView(at: 0) as? AnimationCard {
            animationCard.playAnimation()
            previousItem = animationCard
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
        return characterData != nil ? characterData.count : 0
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let animationCard = AnimationCard(frame: AnimationCard.expectedFrame)
        animationCard.isOpaque = false
        
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
