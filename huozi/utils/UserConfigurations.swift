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
    var val: [Int: [Int: [String]]]
    func toJSON() -> String {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(val) else { return "{}" }
        if let result = String(data: data, encoding: .utf8) {
            return result
        } else { return "{}" }
    }
    init(_ jsonString: String) {
        let serialized = try? JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: .allowFragments)
        if let toNormalize = serialized as? [String: [String: [String]]] {
            val = Dictionary(uniqueKeysWithValues: toNormalize.map { key, value in (Int(key)!, Dictionary(uniqueKeysWithValues: value.map { key, value in (Int(key)!, value) }))})
        } else {
            val = [:]
        }
    }
}

struct MedalCollection {
    struct Record: Equatable {
        var book: Int
        var story: Int
        var timeStamp: Int
        init(book: Int, story: Int)
            { self.book = book; self.story = story; self.timeStamp = Int(Date().timeIntervalSince1970 * 1000) }
        init(_ array: [Int]) {
            self.book = array[0]
            self.story = array[1]
            if array.count > 2 {
                self.timeStamp = array[2]
            } else {
                self.timeStamp = Int(Date().timeIntervalSince1970 * 1000)
            }
        }
        static func == (lhs: Record, rhs: Record) -> Bool
            { return lhs.book == rhs.book && lhs.story == rhs.story }
    }
    var val: [Record]
    func toJSON() -> String {
        let encoder = JSONEncoder()
        let toEncode = val.map({ (rec) -> [Int] in return [rec.book, rec.story, rec.timeStamp] })
        guard let data = try? encoder.encode(toEncode) else { return "[]" }
        if let result = String(data: data, encoding: .utf8) {
            return result
        } else { return "[]" }
    }
    init(_ jsonString: String) {
        let serialized = try? JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: .allowFragments)
        if serialized is [[Int]] {
            val = (serialized as! [[Int]]).map { item in Record(item) }
        } else {
            val = []
        }
    }
}

// Singleton with static interface
// Why do we need a singleton?
// Cause we want it initialized when it is first used
// But not at the import time
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
    
    static func hasStoryMedal(book: Int, story: Int) -> Bool {
        return instance.medals.val.contains(MedalCollection.Record(book: book, story: story))
    }
    static func addMedal(book: Int, story: Int) {
        // Do nothing if we have already get the medal
        if instance.medals.val.contains(MedalCollection.Record(book: book, story: story)) { return }
        // Otherwise we get a medal
        instance.medals.val.append(MedalCollection.Record(book: book, story: story))
        updateStorage()
    }
    static func characterDone(book: Int, story: Int, character: String) -> Bool {
        if let storyProgress = instance.progress.val[book]?[story],
                  storyProgress.contains(character) { return true }
        else { return false }
    }
    static func allCharactersDone(book: Int, story: Int) -> Bool {
        return instance.progress.val[book]?[story]?.count == UserState.currentStory.characters.count
    }
    static func addCharacterProgress(book: Int, story: Int, character: String) {
        if instance.progress.val[book] == nil {
            instance.progress.val[book] = [:]
        }
        if instance.progress.val[book]?[story] == nil {
            instance.progress.val[book]![story] = []
        }
        guard (instance.progress.val[book]?[story]?.contains(character))! else {
            instance.progress.val[book]![story]!.append(character)
            updateStorage()
            return
        }
    }
    
    static func isUnlocked(storyData: StoryData) -> Bool {
        if storyData.primaryUnlocked { return true }
        if hasStoryMedal(book: UserState.currentBook.index, story: storyData.index) { return true }
        
        // NOTE: It's dangerous here. TODO: Refactor this later!
        let previousI = UserState.storiesInCurrentBook.data.map({ story in story.index }).index(of: storyData.index)! - 1
        if previousI < 0 { return true }
        let previousIndex = UserState.storiesInCurrentBook.data[previousI].index!
        if hasStoryMedal(book: UserState.currentBook.index, story: previousIndex) { return true }
        
        return false
    }
    
    
    static func updateStorage() {
        let keyStore = NSUbiquitousKeyValueStore()
        // Update the process
        keyStore.set(instance.progress.toJSON(), forKey: processKey)
        // Update the medals
        keyStore.set(instance.medals.toJSON(), forKey: medalsKey)
    }
    
    // This will clear up the storage forever
    static func clear() {
        let keyStore = NSUbiquitousKeyValueStore.default
        keyStore.removeObject(forKey: processKey)
        keyStore.removeObject(forKey: medalsKey)
        _instance = nil
    }
    
    private init() {
        // Set up the progress member
        let keyStore = NSUbiquitousKeyValueStore.default
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
