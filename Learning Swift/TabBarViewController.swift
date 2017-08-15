//
//  TabBarViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 15/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        log.debug("view did load")
    }

    deinit {
        log.debug("deinit tabBarController")
    }

}
