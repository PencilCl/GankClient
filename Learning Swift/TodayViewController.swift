//
//  TodayViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 15/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {
    
    let data = [
        ["category": "iOS",
         "data": [
            ["title": "标题",
             "url": "url",
             "author": "作者"],
            ["title": "标题",
             "url": "url",
             "author": "作者"],
            ["title": "标题",
             "url": "url",
             "author": "作者"],
            ["title": "标题",
             "url": "url",
             "author": "作者"]
            ]
        ],
        ["category": "Android",
         "data": [
            ["title": "标题",
             "url": "url",
             "author": "作者"]
            ]
        ],
        ["category": "前端",
         "data": [
            ["title": "标题",
             "url": "url",
             "author": "作者"]
            ]
        ],
        ["category": "瞎推荐",
         "data": [
            ["title": "标题",
             "url": "url",
             "author": "作者"]
            ]
        ],
        ["category": "休息视频",
         "data": [
            ["title": "标题",
             "url": "url",
             "author": "作者"]
            ]
        ],
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "GankTableViewCell", bundle: nil), forCellReuseIdentifier: "GankData")
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
    }

}

extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }«
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (data[section]["data"] as? [[String: String]])?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "sectionHeader"),
            let header = cell as? HeaderTableViewCell {
            header.title = data[section]["category"] as? String
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GankData", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        log.debug("\(indexPath.row) row \(indexPath.section) section")
    }
}
