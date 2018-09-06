//
//  medalCollectionView.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/9/5.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit
import Hero

class MedalCollectionViewController: UIViewController {
    private let medalCarouselSegueIdentifier = "medalCarouselSegue"
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var medalLabel: UILabel!
    @IBOutlet weak var emptyPlaceholder: UIView!
    
    override func viewDidLoad() {
        hero.modalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .pull(direction: .right))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == medalCarouselSegueIdentifier {
            if let dest = segue.destination as? MedalCarouselViewController {
                dest.pageControl = pageControl
                dest.medalLabel = medalLabel
                dest.emptyPlaceholder = emptyPlaceholder
            }
        }
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true) {}
    }
}


class MedalCarouselViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    @IBOutlet weak var carouselView: iCarousel!
    weak var pageControl: UIPageControl!
    weak var medalLabel: UILabel!
    weak var emptyPlaceholder: UIView!
    
    override func viewDidLoad() {
        if carouselView != nil {
            carouselView.type = .rotary
            carouselView.isPagingEnabled = true
            carouselView.delegate = self
            carouselView.dataSource = self
        }
        
        if pageControl != nil {
            pageControl.numberOfPages = carouselView.numberOfItems
        }
        if medalLabel != nil && carouselView.numberOfItems > 0 {
            medalLabel.text = UserProgressModel.medalStories[carouselView.currentItemIndex].medalName
        }
        
        // empty
        if carouselView.numberOfItems <= 0 {
            pageControl.isHidden = true
            medalLabel.isHidden = true
            carouselView.isHidden = true
            emptyPlaceholder.isHidden = false
        } else {
            pageControl.isHidden = false
            medalLabel.isHidden = false
            carouselView.isHidden = false
            emptyPlaceholder.isHidden = true
        }
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if pageControl != nil {
            pageControl.currentPage = carouselView.currentItemIndex
        }
        if medalLabel != nil && carouselView.numberOfItems > 0 {
            medalLabel.text = UserProgressModel.medalStories[carouselView.currentItemIndex].medalName
        }
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return UserProgressModel.medalStories.count
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
            case .spacing       : return value * 0.3
            case .fadeMin       : return 0
            case .fadeMax       : return 0
            case .fadeRange     : return 4
            default             : return value
        }
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        return UIImageView(image: UIImage(named: UserProgressModel.medalStories[index].medalImageName))
    }
}
