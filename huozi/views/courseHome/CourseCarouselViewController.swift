//
//  CourseCarouselViewController.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/23.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

class CourseCarouselViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    @IBOutlet var carouselView: iCarousel!
    
    override func viewDidLoad() {
        carouselView.type = .rotary
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 10
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        let frame = CGRect(x: 0, y: 0, width: 200, height: 300)
        let imageView = UIImageView()
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = #imageLiteral(resourceName: "defaultStoryBackground")
        view.addSubview(imageView)
        
        return view
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return value * 0.2
        }
        return value
    }
}
