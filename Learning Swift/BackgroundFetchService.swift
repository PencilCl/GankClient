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
    
    class func performBackgroundFetch(_ completion: @escaping (UIBackgroundFetchResult) -> Void) {
        // 今天已成功获取过则不再通知
        if let date = GankUserDefaults.latestFetchDate,
            Calendar.current.isDate(date, inSameDayAs: Date()) {
            completion(.noData)
            return
        }
        
        GankService.getLatestDate { (date, error) in
            if let date = date,
                Calendar.current.isDate(date, inSameDayAs: Date()) {
                GankNotification.push()
                GankUserDefaults.latestFetchDate = Date()
                completion(.newData)
            } else {
                completion(.failed)
            }
        }
    }
    
}
