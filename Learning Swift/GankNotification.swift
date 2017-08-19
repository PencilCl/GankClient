//
//  GankNotification.swift
//  Learning Swift
//
//  Created by 陈林 on 19/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import UserNotifications

final public class GankNotification {
    /*
     Check authorization
     If notDetermined, it will request authorization
    */
    class func checkAuthorization(_ callback: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized:
                    callback(true)
                case .denied:
                    callback(false)
                case .notDetermined:
                    authorize(callback)
                }
            }
        }
    }
    
    class func authorize(_ callback: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            callback(granted)
        }
    }
    
    class func push() {
        let content = UNMutableNotificationContent()
        content.title = "干货更新啦！"
        content.body = "今天的干货很棒，欢迎戳来看预览~ "
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        let requestIdentifier = "gank updates"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
