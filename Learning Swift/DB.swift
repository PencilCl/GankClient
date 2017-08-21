//
//  DB.swift
//  Learning Swift
//
//  Created by 陈林 on 20/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SwiftyJSON

final public class DB {
    static var app: AppDelegate = {
        UIApplication.shared.delegate as! AppDelegate
    }()
    
    static var context: NSManagedObjectContext = {
        app.persistentContainer.viewContext
    }()
    
    static let gankEntityName = "Gank"
    static let gankImageEntityName = "GankImage"
    static let gankHistoryEntityName = "GankHistory"
    
    public class func saveChanges() {
        app.saveContext()
    }

    public class func insertGank(_ value: JSON) -> Gank {
        let id = value["_id"].stringValue
        
        // 如果已存在则直接返回数据库中的数据
        let request: NSFetchRequest<Gank> = Gank.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            let fetchResults = try context.fetch(request)
            if let gank = fetchResults.first {
                return gank
            }
        } catch {
            log.error("fetch gank error")
        }
        
        let gank =  NSEntityDescription.insertNewObject(forEntityName: gankEntityName, into: context) as! Gank
        
        gank.id = id
        gank.desc = value["desc"].stringValue
        gank.publishedAt = formatGankDate(value["publishedAt"].stringValue)! as NSDate
        gank.type = value["type"].stringValue
        gank.url = value["url"].stringValue
        gank.used = value["used"].boolValue
        gank.who = value["who"].stringValue
        
        // 插入图片
        if let images = value["images"].array {
            for imageUrl in images {
                let gankImage = insertGankImage(imageUrl.stringValue)
                gankImage.gank = gank
            }
        }
        
        return gank
    }
    
    /*
     获取数据库中最近一天的数据
     */
    public class func getLatestGanks() -> [Gank] {
        let request: NSFetchRequest<Gank> = Gank.fetchRequest()
        do {
            let fetchResults = try context.fetch(request)
            var ganks = [Gank]()
            if let first = fetchResults.first {
                ganks.append(first)
                let date = first.publishedAt! as Date
                for gank in ganks {
                    if (Calendar.current.isDate(gank.publishedAt! as Date, inSameDayAs: date)) {
                        ganks.append(gank)
                    }
                }
            }
            return ganks
        } catch {
            log.error("fetch latest ganks error")
            return [Gank]()
        }
    }
    
    public class func getGanks(date: Date) -> [Gank] {
        let request: NSFetchRequest<Gank> = Gank.fetchRequest()
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
        request.predicate = NSPredicate(format: "(publishedAt >= %@) AND (publishedAt < %@)", [date, endDate])
        do {
            return try context.fetch(request)
        } catch {
            log.error("fetch ganks error")
        }
        
        return [Gank]()
    }
    
    public class func insertGankImage(_ url: String) -> GankImage {
        let gankImage = NSEntityDescription.insertNewObject(forEntityName: gankImageEntityName, into: context) as! GankImage
        gankImage.url = url
        return gankImage
    }
    
    public class func insertGankHistory(_ dateStr: String) -> GankHistory {
        let date = Date.fromString(dateStr)! as NSDate
        
        // 如果已存在直接返回数据库中的数据
        let request: NSFetchRequest<GankHistory> = GankHistory.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", date)
        do {
            let fetchResults = try context.fetch(request)
            if let gankHistory = fetchResults.first {
                return gankHistory
            }
        } catch {
            log.error("fetch GankHistory error")
        }
        
        let gankHistory = NSEntityDescription.insertNewObject(forEntityName: gankHistoryEntityName, into: context) as! GankHistory
        gankHistory.date = date
        return gankHistory
    }
    
    /*
     获取数据库中发布过Gank数据的最近一天的日期
     */
    public class func getLatestDate() -> Date? {
        let request: NSFetchRequest<GankHistory> = GankHistory.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        do {
            let fetchResults = try context.fetch(request)
            if let gankHistory = fetchResults.first {
                return gankHistory.date! as Date
            }
        } catch {
            log.error("fetch gank history failed")
        }
        
        return nil
    }
    
    /*
     将Gank提供的日期字符串2016-05-11T12:11:48.690Z
     转换为Date日期
     */
    private class func formatGankDate(_ string: String) -> Date? {
        // 先将日期格式转换为 2016-05-11 12:11:48
        let tmp = string.substring(to: string.index(string.startIndex, offsetBy: 19))
                        .replacingOccurrences(of: "T", with: " ")
        return Date.fromString(tmp, format: "YYYY-MM-dd hh:mm:ss")
    }
}


