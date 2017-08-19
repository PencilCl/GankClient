//
//  NotifitionViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 19/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class NotifitionViewController: UIViewController {
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var notificationSwitcher: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgImageView.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "bg"))
        notificationSwitcher.isOn = GankUserDefaults.enabledBackground
    }
    
    @IBAction func switchNotification(_ sender: UISwitch) {
        if sender.isOn {
            GankNotification.checkAuthorization { success in
                if success {
                    GankUserDefaults.enabledBackground = true
                    BackgroundFetchService.turnOn()
                } else {
                    log.debug("request authorization fail")
                    sender.isOn = false
                }
            }
        } else {
            GankUserDefaults.enabledBackground = false
            BackgroundFetchService.turnOff()
        }
    }
}
