//
//  TemporaryUserStateModel.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/31.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import Foundation

struct UserProgress {
    // [BookIndex: [StoryIndex: [CharacterIndices]]]
    var val: [Int: [Int: [Int]]]
    func toJSON() -> String {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(val) else { return "{}" }
        if let result = String(data: data, encoding: .utf8) {
            return result
        } else { return "{}" }
    }
    init(_ jsonString: String) {
        let serialized = try? JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: .allowFragments)
        if serialized is [Int: [Int: [Int]]] {
            val = serialized as! [Int : [Int : [Int]]]
        } else {
            val = [:]
        }
    }
}

struct MedalCollection {
    struct Pair: Equatable {
        var book: Int
        var story: Int
        init(book: Int, story: Int)
            { self.book = book; self.story = story }
        init(_ array: [Int])
            { self.book = array[0]; self.story = array[1] }
        static func == (lhs: Pair, rhs: Pair) -> Bool
            { return lhs.book == rhs.book && lhs.story == rhs.story }
    }
    var val: [Pair]
    func toJSON() -> String {
        let encoder = JSONEncoder()
        let toEncode = val.map({ (pair) -> [Int] in return [pair.book, pair.story] })
        guard let data = try? encoder.encode(toEncode) else { return "[]" }
        if let result = String(data: data, encoding: .utf8) {
            return result
        } else { return "[]" }
    }
    init(_ jsonString: String) {
        let serialized = try? JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: .allowFragments)
        if serialized is [[Int]] {
            val = (serialized as! [[Int]]).map({ (array) -> Pair in return Pair(array) })
        } else {
            val = []
        }
    }
}

// Singleton with static interface
class UserProgressModel {
    var progress: UserProgress!
    var medals: MedalCollection!
    // The key used for iCloud key-value storage
    static let processKey = "progress"
    static let medalsKey = "medals"
    
    private static var _instance: UserProgressModel!
    static var instance: UserProgressModel {
        get {
            if UserProgressModel._instance == nil {
                UserProgressModel._instance = UserProgressModel()
            }
            return _instance
        }
    }
    
    static var characterDone: [Bool] = Array(repeating: false, count: 6)
    static var shownMedal: Bool = false
    
    static func storyMedal(book: Int, story: Int) -> Bool {
        return instance.medals.val.contains(MedalCollection.Pair([book, story]))
    }
    
    private init() {
        // Set up the progress member
        let keyStore = NSUbiquitousKeyValueStore()
        if let progressString = keyStore.string(forKey: UserProgressModel.processKey) {
            progress = UserProgress(progressString)
        } else {
            let defaultProgressString = "{}"
            progress = UserProgress(defaultProgressString)
            keyStore.set(defaultProgressString, forKey: UserProgressModel.processKey)
        }
        if let medalsString = keyStore.string(forKey: UserProgressModel.medalsKey) {
            medals = MedalCollection(medalsString)
        } else {
            let defaultMedalsString = "[]"
            medals = MedalCollection(defaultMedalsString)
            keyStore.set(defaultMedalsString, forKey: UserProgressModel.medalsKey)
        }
    }
}
