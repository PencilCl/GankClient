//
//  BaiduTableViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 20/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class GankTableViewController: UITableViewController {
    
    private var ganks: [Gank]? {
        didSet {
            if ganks != nil {
                print(ganks!)
            }
        }
    }
    
    private var lastCategory: String?
    private var type: String? {
        didSet {
            if let category = type, !category.isEmpty {
                lastCategory = category
                GankService.fetchGanks(category: category, count: 20, page: 1, { [weak self] newGanks in
                    if self?.lastCategory == category {
                        self?.ganks = newGanks
                        DispatchQueue.main.async { [weak self] in
                            self?.tableView.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        type = "iOS"
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ganks == nil ? 0 : ganks!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gank", for: indexPath)

        let gank = ganks?[indexPath.row]
        if let gankTableViewCell = cell as? GankTableViewCell {
            gankTableViewCell.gank = gank
        }

        return cell
    }
}
