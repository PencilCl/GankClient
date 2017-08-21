//
//  GankUserDefaults.swift
//  Learning Swift
//
//  Created by 陈林 on 19/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation

final public class GankUserDefaults {
    // 是否开启后台刷新干货推送信息
    static private let enabledBackgroundKey = "enabledBackground"
    // 最后一次获取数据成功日期, 当天没有数据也算获取成功
    static private let latestFetchDateKey = "latestFetchDate"
    
    static let userDefaults = UserDefaults.standard
    
    public static var enabledBackground: Bool {
        get {
            return userDefaults.bool(forKey: enabledBackgroundKey)
        }
        set {
            userDefaults.set(newValue, forKey: enabledBackgroundKey)
        }
    }
    
    public static var latestFetchDate: Date? {
        get {
            return userDefaults.object(forKey: latestFetchDateKey) as? Date
        }
        set {
            userDefaults.set(newValue, forKey: latestFetchDateKey)
        }
    }
}
