//
//  PictureViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 19/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController, UISplitViewControllerDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ivc = segue.destination.contents as? ImageViewController {
            if let id = segue.identifier,
                let url = picturesUrl[id] {
                ivc.imageUrl = url
                ivc.title = (sender as? UIButton)?.currentTitle
            }
        }
    }
    
    let picturesUrl = [
        "picture1": URL(string: "http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=0eccdac9a3ec8a1300175fa39f6afbfa/622762d0f703918ff90cc3ec5b3d269759eec433.jpg"),
        "picture2": URL(string: "http://www.tonie.net/images/sanjose2001/siliconvalley/stanford/stanford_towergreen.jpg"),
        "picture3": URL(string: "http://s1.sinaimg.cn/mw690/73ee7d09gcc3047ca0740&690")
    ]
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contents == self {
            if let ivc = secondaryViewController.contents as? ImageViewController, ivc.imageUrl == nil {
                return true
            }
        }
        return false
    }
}

extension UIViewController {
    var contents: UIViewController {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController ?? self
        } else {
            return self
        }
    }
}
