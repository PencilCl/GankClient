//
//  GankUserDefaults.swift
//  Learning Swift
//
//  Created by 陈林 on 19/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation

final public class GankUserDefaults {
    static private let enabledBackgroundKey = "enabledBackground"
    
    static let userDefaults = UserDefaults.standard
    
    public static var enabledBackground: Bool {
        get {
            return userDefaults.bool(forKey: enabledBackgroundKey)
        }
        set {
            userDefaults.set(newValue, forKey: enabledBackgroundKey)
        }
    }
}
