//
//  DataHandler.swift
//  huozi
//
//  Created by Celestial Phineas on 2018/7/18.
//  Copyright © 2018年 Celestial Phineas. All rights reserved.
//

import UIKit
import Foundation

final class DataHandler {
    static let instance = DataHandler()
    private var json: NSObject!         = nil
    private var objs: [[String: Any]]!  = nil
    
    private init() {
        let asset = NSDataAsset(name: "data")
        let serialized = try? JSONSerialization.jsonObject(with: asset!.data, options: JSONSerialization.ReadingOptions.allowFragments)
        if serialized != nil {
            json = serialized as! NSObject
            objs = []
            for item in json as! [[String: Any]] {
                objs.append(item)
            }
        }
    }
    
    var count: Int { get { return data.count } }
    static var count: Int { get { return instance.count } }
    var data: [[String: Any]]! { get { return objs }}
    static var data: [[String: Any]]! { get { return instance.objs } }
}
