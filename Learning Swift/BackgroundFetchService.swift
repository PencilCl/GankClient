//
//  BackgroundFetchService.swift
//  Learning Swift
//
//  Created by 陈林 on 19/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import UIKit

final class BackgroundFetchService {
    class func setup() {
        GankUserDefaults.enabledBackground ? BackgroundFetchService.turnOn() : BackgroundFetchService.turnOff()
    }
    
    class func turnOn() {
        log.debug("turn on background fetch")
        GankUserDefaults.enabledBackground = true
        UIApplication.shared.setMinimumBackgroundFetchInterval(3600)
    }
    
    class func turnOff() {
        log.debug("turn off background fetch")
        GankUserDefaults.enabledBackground = false
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalNever)
    }
    
    class func performBackgroundFetch(_ completion: (UIBackgroundFetchResult) -> Void) {
        completion(.noData)
    }
    
}
