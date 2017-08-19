//
//  GankListViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 17/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class GankListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "GankTableViewCell", bundle: nil), forCellReuseIdentifier: "GankData")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
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
    
    deinit {
        log.debug("deinit: \(type(of: self))")
    }

}

extension GankListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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
