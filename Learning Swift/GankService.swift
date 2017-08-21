//
//  GankService.swift
//  Learning Swift
//
//  Created by 陈林 on 19/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class GankService {
    /*
     获取最新一天的Gank数据
     获取失败将返回数据库中最近一天的数据
     若数据库中也不存在，将返回空数组
     */
    class func fetchLatestData(_ completion: @escaping (_ data: [Gank], _ error: GankError?) -> Void) {
        getLatestDate { (date, error) in
            if let date = date {
                getSomedayData(date: date, { ganks in
                    if ganks.count == 0 {
                        // 如果获取最近一天数据失败，则从数据库返回最近一天的数据
                        completion(DB.getLatestGanks(), nil)
                    } else {
                        completion(ganks, nil)
                    }
                })
            } else {
                completion([Gank](), error)
            }
        }
    }
    
    /*
     获取最近一天发布过Gank数据的日期
     从网络获取失败将返回数据库中最近一天的数据
     若数据库中不存在，将返回nil
     */
    class func getLatestDate(_ completion: @escaping (_ data: Date?, _ error: GankError?) -> Void) {
        fetchHistory { (dates, error) in
            if error != nil {
                if let date = DB.getLatestDate() {
                    completion(date, nil)
                } else {
                    completion(nil, error)
                }
                return
            }
            
            let sortedDates = dates.sorted { $0 > $1 }
            completion(sortedDates.first, nil)
        }
    }
    
    /*
     获取某天的Gank数据
     */
    class func getSomedayData(date: Date, _ completion: @escaping (_ data: [Gank]) -> Void) {
        fetchSomedayData(date: date) { (ganks, error) in
            if error != nil {
                completion(DB.getGanks(date: date))
            } else {
                completion(ganks)
            }
        }
    }
    
    /*
     从网络获取某天的Gank数据
     */
    private class func fetchSomedayData(date: Date, _ completion: @escaping (_ data: [Gank], _ error: GankError?) -> Void) {
        let url = BASE_URL + "/day/\(date.toString(format: "YYYY/MM/dd"))"
        log.debug("fetch someday date url: \(url)")
        
        Alamofire.request(url)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let (ganks, error) = parseSomedayGanks(JSON(value))
                    completion(ganks, error)
                case .failure(_):
                    completion([Gank](), .requestError)
                }
        }
    }
    
    private class func parseSomedayGanks(_ value: JSON) -> ([Gank], GankError?) {
        var ganks = [Gank]()
        guard value["error"].boolValue == false else {
            return (ganks, .unkownError)
        }
        
        let results = value["results"]
        for (_, subJson):(String, JSON) in results {
            for (_, gankJson):(String, JSON) in subJson {
                ganks.append(DB.insertGank(gankJson))
            }
        }
        
        DB.saveChanges()
        
        return (ganks, nil)
    }
    
    class func fetchHistory(_ completion: @escaping (_ data: [Date], _ error: GankError?) -> Void) {
        let url = BASE_URL + "/day/history"
        log.debug("fetch history")
        
        Alamofire.request(url)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let (dates, error) = parseHistoryDates(JSON(value))
                    completion(dates, error)
                case .failure(_):
                    completion([Date](), .requestError)
                }
                
        }
    }
    
    private class func parseHistoryDates(_ value: JSON) -> ([Date], GankError?) {
        var dates = [Date]()
        guard value["error"].boolValue == false else {
            return (dates, .unkownError)
        }
        
        let results = value["results"]
        for (_, dateJson):(String, JSON) in results {
            let gankHistory = DB.insertGankHistory(dateJson.stringValue)
            dates.append(gankHistory.date! as Date)
        }
        
        DB.saveChanges()
        
        return (dates, nil)
    }
    
    class func fetchGanksByCategory(category: Category, count: Int = REQUEST_NUMS, page: Int, _ completion: @escaping (_ data: [Gank], _ error: GankError?) -> Void) {
        let url = BASE_URL + "/\(category.rawValue)/\(count)/\(page)"
        log.debug("fetch ganks by category url: \(url)")
        
        Alamofire.request(url)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let (ganks, error) = parseCategoryGanks(JSON(value))
                    completion(ganks, error)
                case .failure(_):
                    completion([Gank](), .requestError)
                }
        }
    }
    
    private class func parseCategoryGanks(_ value: JSON) -> ([Gank], GankError?) {
        var ganks = [Gank]()
        guard value["error"].boolValue == false else {
            return (ganks, .unkownError)
        }
        
        let results = value["results"]
        for (_, subJson):(String, JSON) in results {
            ganks.append(DB.insertGank(subJson))
        }
        
        return (ganks, nil)
    }
    
    class func search(content: String, count: Int = REQUEST_NUMS, page: Int, _ completion: @escaping (_ data: [Gank], _ error: GankError?) -> Void) {
        let url = BASE_URL + "/search/query/\(content)/category/all/count/\(count)/page/\(page)"
        log.debug("search url: \(url)")
        
        Alamofire.request(url)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let (ganks, error) = parseSearchGanks(JSON(value))
                    completion(ganks, error)
                case .failure(_):
                    completion([Gank](), .requestError)
                }
        }
    }
    
    private class func parseSearchGanks(_ value: JSON) -> ([Gank], GankError?) {
        var ganks = [Gank]()
        guard value["error"] == false else {
            return (ganks, .unkownError)
        }
        
        let results = value["results"]
        for (_, subJson):(String, JSON) in results {
            var gankJson = subJson
            gankJson["_id"] = subJson["ganhuo_id"]
            ganks.append(DB.insertGank(gankJson))
        }
        
        return (ganks, nil)
    }
    
}
