//
//  TodayViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 15/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit
import SKPhotoBrowser

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
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "GankTableViewCell", bundle: nil), forCellReuseIdentifier: "GankData")
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImage)))
    }
    
    @objc func showImage() {
        var images = [SKPhoto]()
        if let image = imageView.image {
            let photo = SKPhoto.photoWithImage(image)
            images.append(photo)
        } else {
            let photo = SKPhoto.photoWithImageURL("https://i.stack.imgur.com/qdDEU.png")
            photo.shouldCachePhotoURLImage = false
            images.append(photo)
        }
        
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "GankDetail":
                if let gankCV = segue.destination as? WebViewController {
                    gankCV.url = URL(string: "https://www.baidu.com")!
                }
            default:
                break
            }
        }
    }
}

extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
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
        
        performSegue(withIdentifier: "GankDetail", sender: nil)
    }
}
