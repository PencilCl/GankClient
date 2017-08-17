//
//  GankTableViewCell.swift
//  Learning Swift
//
//  Created by 陈林 on 17/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class GankTableViewCell: UITableViewCell {
    @IBOutlet weak var dotImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var sortLabel: UILabel!

    static let COLOR_SORT_MAP = [
        "iOS": UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 1),
        "Android": UIColor(red: 164 / 255.0, green: 198 / 255.0, blue: 57 / 255.0, alpha: 1),
        "前端": UIColor(red: 226 / 255.0, green: 70 / 255.0, blue: 40 / 255.0, alpha: 1),
        "拓展资源": UIColor(red: 37 / 255.0, green: 82 / 255.0, blue: 131 / 255.0, alpha: 1),
        "App": UIColor(red: 83 / 255.0, green: 187 / 255.0, blue: 249 / 255.0, alpha: 1),
        "瞎推荐": UIColor(red: 239 / 255.0, green: 223 / 255.0, blue: 25 / 255.0, alpha: 1),
        "休息视频": UIColor(red: 245 / 255.0, green: 166 / 255.0, blue: 35 / 255.0, alpha: 1),
        "福利": UIColor(red: 159 / 255.0, green: 105 / 255.0, blue: 50 / 255.0, alpha: 1),
    ]
    
    
}
