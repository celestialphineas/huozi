//
//  TemporaryUserStateModel.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/31.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import Foundation
import CloudKit

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
        private static var medalNameTable: [Int:[Int:StoryData]]!
        var book: Int
        var story: Int
        var timeStamp: Int
        var storyObject: StoryData? {
            get { return MedalCollection.Record.medalNameTable[book]?[story] }
        }
        static func initMedalNameTable() {
            medalNameTable = [:]
            if let books = Books().data { for book in books {
                if let stories = StoryDataOf(book.entry).data { for story in stories {
                    if medalNameTable[book.index] == nil { medalNameTable[book.index] = [:] }
                    medalNameTable[book.index]![story.index] = story
                }}
            }}
        }
        
        init(book: Int, story: Int) {
            if MedalCollection.Record.medalNameTable == nil { MedalCollection.Record.initMedalNameTable() }
            self.book = book; self.story = story; self.timeStamp = Int(Date().timeIntervalSince1970)
        }
        init(_ array: [Int]) {
            if MedalCollection.Record.medalNameTable == nil { MedalCollection.Record.initMedalNameTable() }
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
    static var medalStories: [StoryData] { get {
        return instance.medals.val.map({ record in record.storyObject }).filter({ str in str != nil }).map({ obj in obj! })
    }}
    
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

class UserInfo {
    private static var _instance: UserInfo!
    private static let recordName = "default"
    private static let recordType = "Avatar"
    private static let avartarKey = "avatarImage"
    static var instance: UserInfo { get {
        if _instance == nil { _instance = UserInfo() }
        return _instance
    }}
    
    static var avatarImage: UIImage {
        get { return instance.avatarImage ?? UIImage(named: "defaultAvatar")! }
    }
    private let cloudDB: CKDatabase!
    private var avatarImage: UIImage!
    
    init() {
        cloudDB = CKContainer.default().privateCloudDatabase
        getAvatar { image, error in
            if image != nil { self.avatarImage = image! }
            else { NSLog("CloudKit user avatar image not found!") }
        }
    }
    
    // Communicating with iCloud
    private func createRecord(_ callback: ((CKRecord?, Error?)->Void)!) {
        let record = CKRecord(recordType: UserInfo.recordType, recordID: CKRecordID(recordName: UserInfo.recordName))
        cloudDB.save(record) { record, error in
            if callback != nil { callback(record, error) }
        }
    }
    private func getAvatar(_ callback: ((UIImage?, Error?)->Void)!) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: UserInfo.recordType, predicate: predicate)
        let queryOperation = CKQueryOperation()
        queryOperation.query = query
        queryOperation.resultsLimit = 5
        queryOperation.qualityOfService = .userInteractive
        queryOperation.recordFetchedBlock = { record in
            let asset = record.object(forKey: UserInfo.avartarKey) as? CKAsset
            if asset != nil {
                do {
                    let photoData = try Data(contentsOf: asset!.fileURL)
                    let img = UIImage(data: Data(photoData))
                    NSLog("Things should work!")
                    if callback != nil { callback(img, nil) }
                } catch let error {
                    if callback != nil { callback(nil, error) }
                    NSLog("getAvatar case 1: \(error)")
                }
                return
            } else {
                do {
                    enum GetAvatarErr: Error { case cloudKitError }
                    throw GetAvatarErr.cloudKitError
                } catch let error {
                    if callback != nil { callback(nil, error) }
                    NSLog("getAvatar case 2: \(error)")
                }
            }
        }
        cloudDB.add(queryOperation)
    }
    static func storeAvatar(path: URL, _ callback: ((CKRecord?, Error?)->Void)!) {
        instance.cloudDB.fetch(withRecordID: CKRecordID(recordName: recordName)) { record, error in
            func doModify(record: CKRecord?, error: Error?) {
                let asset = CKAsset(fileURL: path)
                let data = try? Data(contentsOf: path)
                instance.avatarImage = data != nil ? UIImage(data: data!) : instance.avatarImage
                record![avartarKey] = asset
                instance.cloudDB.save(record!) { record, error in
                    if callback != nil { callback(record, error) }
                }
            }
            if record != nil { doModify(record: record, error: error) }
            else {
                // record == nil or error occurs
                instance.createRecord { record, error in
                    if record != nil { doModify(record: record, error: error) }
                    else { if callback != nil { callback(record, error) } }
                }
            }
        }
    }
}
