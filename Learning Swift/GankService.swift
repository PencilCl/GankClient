//
//  Gank.swift
//  Learning Swift
//
//  Created by 陈林 on 20/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation

class GankService {
    static private let apiURL = "http://gank.io/api/data/%s/%d/%d" // category/count/page
    
    class public func fetchGanks(category: String, count: Int, page: Int, _ callback: @escaping ([Gank]?) -> Void) {
        DispatchQueue.global().async {
            if let url = URL(string: "http://gank.io/api/data/iOS/20/1"),
                let data = try? Data(contentsOf: url),
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let results = json?["results"] as? NSArray {
                    var ganks = [Gank]()
                    for result in results {
                        if let gank = result as? [String: Any],
                            let desc = gank["desc"] as? String,
                            let created = gank["createdAt"] as? String,
                            let who = gank["who"] as? String {
                            var image: String? = nil
                            if let images = gank["images"] as? NSArray, images.count > 0 {
                                image = images.object(at: 0) as? String
                            }
                            ganks.append(Gank(description: desc, created: created, image: image, who: who))
                        }
                    }
                    callback(ganks)
                }
            }
        }
    }
}
