//
//  File.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/20.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import Foundation

// Abstract of a book
class BookData {
    var name:               String!
    var index:              Int!
    var entry:              String!
    var storyCount:         Int!
    
    init(_ data: [String:Any]) {
        name                = data["name"]          as? String
        index               = data["index"]         as? Int
        entry               = data["entry"]         as? String
        storyCount          = data["storycount"]    as? Int
    }
}

// Abstract of each story data, initialized with a dict of [String:Any]
class StoryData {
    var index:              Int!
    var category:           String!
    var title:              String!
    var imageName:          String!
    var cardImageName:      String!
    var medalImageName:     String!
    var medalDescription:   String!
    var plain:              String!
    var bySentence:         [String]!
    var characters:         [String]!
    
    init(_ data: [String:Any]) {
        index               = data["index"]         as? Int
        category            = data["category"]      as? String
        title               = data["title"]         as? String
        imageName           = data["bgimg"]         as? String
        cardImageName       = data["cardimg"]       as? String
        medalImageName      = data["medalimg"]      as? String
        medalDescription    = data["medaldesc"]     as? String
        plain               = data["plain"]         as? String
        bySentence          = data["bysentence"]    as? [String]
        characters          = data["characters"]    as? [String]
    }
}

// Implementing each data handler should implement this protocols
// The data handlers might be singletons
protocol StoryDataHandler {
    // The data must be an array of dicts
    var data: [StoryData]! { get }
    // The count of data
    var count: Int! { get }
}

class Books {
    private var objs: [BookData]!
    
    var data: [BookData]! {
        get { return objs }
    }
    var count: Int! {
        get { return objs?.count }
    }
    
    // The default asset name is 'manifest'
    init() {
        if let asset = NSDataAsset(name: "manifest") {
            // Serialize the asset data
            let serialized = try? JSONSerialization.jsonObject(with: asset.data, options: JSONSerialization.ReadingOptions.allowFragments)
            if serialized != nil {
                let json = serialized as! NSObject
                objs = []
                if let jsonFull = json as? [String: Any],
                let jsonAsDict = jsonFull["books"] as? [[String: Any]] {
                    for obj in jsonAsDict {
                        objs.append(BookData(obj))
                    }
                }
            }
        } else {
            print("Cannot find asset manifest")
        }
    }
}

// This class returns a StoryDataHandler object of
class StoryDataOf: StoryDataHandler {
    private var objs: [StoryData]!
    
    var data: [StoryData]! {
        get { return objs }
    }
    var count: Int! {
        get { return objs?.count }
    }
    
    init(_ assetName: String) {
        if let asset = NSDataAsset(name: assetName) {
            // Serialize the asset data
            let serialized = try? JSONSerialization.jsonObject(with: asset.data, options: JSONSerialization.ReadingOptions.allowFragments)
            if serialized != nil {
                let json = serialized as! NSObject
                objs = []
                if let jsonAsDict = json as? [[String: Any]] {
                    for obj in jsonAsDict {
                        objs.append(StoryData(obj))
                    }
                }
            }
        } else {
            print("Cannot find asset \"\(assetName)\"")
        }
    }
}

