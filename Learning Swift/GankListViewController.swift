//
//  GankListViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 17/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class GankListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var loadMore = true
    
    var category = Category.all {
        didSet {
            title = category.rawValue
        }
    }
    var page = 1
    var data: [Gank] = [Gank]()
    var isFetching = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "GankTableViewCell", bundle: nil), forCellReuseIdentifier: "GankData")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        fetchData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "GankDetail":
                if let gankCV = segue.destination as? WebViewController,
                    let url = sender as? String {
                    gankCV.url = URL(string: url)!
                }
            default:
                break
            }
        }
    }
    
    func fetchData() {
        if !loadMore || isFetching {
            return
        }
        isFetching = true
        
        GankService.fetchGanksByCategory(category: category, page: page) { [weak self] (ganks, error) in
            self?.isFetching = false
            if error != nil { return }
            
            if ganks.count < REQUEST_NUMS {
                self?.loadMore = false
            }
            
            self?.data += ganks
            self?.page += 1
            self?.tableView.reloadData()
        }
    }
    
    deinit {
        log.debug("deinit: \(type(of: self))")
    }
}

extension GankListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GankData", for: indexPath) as! GankTableViewCell
        cell.gank = data[indexPath.row]
        
        // 显示最后一个时加载更多数据
        if indexPath.row == data.count - 1 {
            fetchData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        let gank = data[indexPath.row]
        let url = gank.url!
        
        if let category = Category(rawValue: gank.type!),
            category == Category.meizi {
            present(PhotoBrowser.photoBrowserController(url: url), animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "GankDetail", sender: url)
        }
    }
}
