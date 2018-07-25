//
//  CharacterDataModel.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/25.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import Foundation

class CharacterData {
    var name:           String = "未定义"
    var pinyin:         String = "无"
    var definition:     String = "没有释义"
    var animationName:  String!
    // The correct answer in the form of a list
    var components:     [String]!
    // Component candidates
    class Component {
        var name:       String!
        var imageName:  String!
        init(_ set: [String: String]) {
            if let m = set["name"]  { self.name       = m }
            if let m = set["img"]   { self.imageName  = m }
        }
    }
    var candidates:     [Component] = []
    
    // The collection of character data
    private static var characterCollection: [String: [String: Any]]!
    private static func initCollection() {
        characterCollection = [:]
        // Get manifest
        if let manifestAsset = NSDataAsset(name: "manifest") {
            let serialized = try? JSONSerialization.jsonObject(with: manifestAsset.data, options: JSONSerialization.ReadingOptions.allowFragments)
            if serialized != nil {
                // Convert the serialized to Swift compatible data structure
                let json = serialized as? [String: Any]
                let packageList = json!["charpackages"] as? [[String: Any]]
                for characterPackage in packageList! {
                    if let filename = characterPackage["file"] as? String {
                        addPackage(filename)
                    }
                }
            }
        } else {
            print("Cannot find the manifest in assets")
        }
    }
    private static func addPackage(_ name: String) {
        // Load the file from assets
        let asset = NSDataAsset(name: name)
        let serialized = try? JSONSerialization.jsonObject(with: asset!.data, options: JSONSerialization.ReadingOptions.allowFragments)
        if serialized is [String: [String: Any]] {
            // Push the character data into characterCollection
            characterCollection.merge(serialized as! [String: [String: Any]]) { (_, new) in new }
        }
    }
    
    init(_ character: String) {
        if CharacterData.characterCollection == nil {
            CharacterData.initCollection()
        }
        if let dataset = CharacterData.characterCollection[character] {
            self.name            = character
            if let m = dataset["pinyin"]        as? String              { self.pinyin           = m }
            if let m = dataset["definition"]    as? String              { self.definition       = m }
            if let m = dataset["animation"]     as? String              { self.animationName    = m }
            if let m = dataset["components"]    as? [String]            { self.components       = m }
            if let m = dataset["candidates"]    as? [[String: String]] {
                for item in m {
                    self.candidates.append(Component(item))
                }
            }
        }
    }
}

