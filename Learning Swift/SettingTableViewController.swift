//
//  SettingTableViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 19/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    @IBOutlet weak var newVersionView: UIView!
    
    static let urlMap = [
        "ThankEditors": URL(string: "http://gank.io/backbone"),
        "ThankGank": URL(string: "http://gank.io/"),
        "AuthorGithub": URL(string: "https://github.com/PencilCl"),
        "ProjectGithub": URL(string: "https://github.com/PencilCl"),
        "AboutAuthor": URL(string: "http://pencilsky.cn/")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier,
            let dstVC = segue.destination as? WebViewController,
            let url = SettingTableViewController.urlMap[identifier] {
            dstVC.url = url
        }
    }

}
