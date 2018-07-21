//
//  File.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/20.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit
import Foundation

// Abstract of each story data, initialized with a dict of [String:Any]
struct StoryData {
    var index:          Int!
    var category:       String!
    var title:          String!
    var cardImage:      UIImage!
    var plain:          String!
    
    init(_ data: [String:Any]) {
        index           = data["index"]     as? Int
        category        = data["category"]  as? String
        title           = data["title"]     as? String
        plain           = data["plain"]     as? String
        if let imgString = data["cardimg"] as? String {
            cardImage = UIImage(named: imgString)
        }
    }
}

// Implementing each data handler should implement this protocols
// The data handlers might be singletons
protocol DataHandler {
    // The data must be an array of dicts
    var data: [StoryData]! { get }
    // The count of data
    var count: Int! { get }
}

// This class is currently the only DataHandler
// and it is a singleton
final class NaiveDataHandler: DataHandler {
    static let instance = NaiveDataHandler()
    private var objs: [StoryData]!
    
    var data: [StoryData]! {
        get { return objs }
    }
    var count: Int! {
        get { return objs?.count }
    }
    
    private init() {
        let asset = NSDataAsset(name: "data")
        let serialized = try? JSONSerialization.jsonObject(with: asset!.data, options: JSONSerialization.ReadingOptions.allowFragments)
        if serialized != nil {
            let json = serialized as! NSObject
            objs = []
            for obj in json as! [[String:Any]] {
                objs.append(StoryData(obj))
            }
        }
    }
    
    static var data: [StoryData]!   { get { return instance.data  }}
    static var count: Int!          { get { return instance.count }}
}
