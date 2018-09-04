//
//  UserState.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/9/2.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

class UserState {
    static var books = Books()
    private static var _currentBook = books.data[0]
    static var storiesInCurrentBook = StoryDataOf(books.data[0].entry)
    static var currentBook: BookData {
        get { return _currentBook }
        set {
            _currentBook = newValue
            storiesInCurrentBook = StoryDataOf(books.data[0].entry)
        }
    }
    static var currentStory: StoryData!
}
