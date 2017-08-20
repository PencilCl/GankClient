//
//  OpenSourceComponentTableViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 19/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class OpenSourceComponentTableViewController: UITableViewController {
    
    let components = [
        ["XCGLogger", "https://github.com/DaveWoodCom/XCGLogger"],
        ["JTAppleCalendar", "https://github.com/patchthecode/JTAppleCalendar"],
        ["SKPhotoBrowser", "https://github.com/suzuki-0000/SKPhotoBrowser"],
        ["SwiftyJSON", "https://github.com/SwiftyJSON/SwiftyJSON"],
        ["Alamofire", "https://github.com/Alamofire/Alamofire"],
        ["RxSwift", "https://github.com/ReactiveX/RxSwift"],
    ]

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return components.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        performSegue(withIdentifier: "ComponentGithub", sender: URL(string: components[indexPath.row][1]))
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = components[indexPath.row][0]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let url = sender as? URL,
            let dstVC = segue.destination as? WebViewController {
            dstVC.url = url
        }
    }

}
