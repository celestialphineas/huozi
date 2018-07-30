//
//  DropShadow.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/20.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit

// This exciting stuff allows you to add members to an interface!
// Why could I do this?
// This will allow you to extend a view with functionality to drop a shadow
// Why not simply extend the UIView class?
// Swift does not support multiple inheritance
public class DropShadowExtension {
    var cornerRadius    : CGFloat   = 5
    var shadowOpacity   : Float     = 0.3
    var shadowRadius    : CGFloat   = 5
    var shadowOffsetX   : CGFloat   = 1
    var shadowOffsetY   : CGFloat   = 2
    private static var baseTable: [UIView: DropShadowExtension] = [:]
    private init(_ base: UIView) {
        type(of: self).baseTable[base] = self
    }
    static func getBase(_ base: UIView) -> DropShadowExtension {
        if let ext = baseTable[base] {
            return ext
        } else {
            return DropShadowExtension(base)
        }
    }
}

public protocol DropsShadow { }

public extension DropsShadow where Self: UIView {
    var cornerRadius    : CGFloat   { get { return DropShadowExtension.getBase(self).cornerRadius   } }
    var shadowOpacity   : Float     { get { return DropShadowExtension.getBase(self).shadowOpacity  } }
    var shadowRadius    : CGFloat   { get { return DropShadowExtension.getBase(self).shadowRadius   } }
    var shadowOffsetX   : CGFloat   { get { return DropShadowExtension.getBase(self).shadowOffsetX  } }
    var shadowOffsetY   : CGFloat   { get { return DropShadowExtension.getBase(self).shadowOffsetY  } }
    
    func cornerRadius(_ v: CGFloat)     { DropShadowExtension.getBase(self).cornerRadius     = v }
    func shadowOpacity(_ v: Float)      { DropShadowExtension.getBase(self).shadowOpacity    = v }
    func shadowRadius(_ v: CGFloat)     { DropShadowExtension.getBase(self).shadowRadius     = v }
    func shadowOffsetX(_ v: CGFloat)    { DropShadowExtension.getBase(self).shadowOffsetX    = v }
    func shadowOffsetY(_ v: CGFloat)    { DropShadowExtension.getBase(self).shadowOffsetY    = v }
    
    func drawShadow() {
        // Make sure that the view allows drawing out of the mask
        self.layer.masksToBounds    = false
        // Shadow parameters
        self.layer.isOpaque = true
        self.layer.cornerRadius     = cornerRadius
        self.layer.shadowOpacity    = shadowOpacity
        self.layer.shadowRadius     = shadowRadius
        self.layer.shadowOffset     = CGSize(width: shadowOffsetX, height: shadowOffsetY)
        // Improve performance with rasterized Bezier path
        self.layer.shadowPath       = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
//        self.layer.shouldRasterize  = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
