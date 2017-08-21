//
//  Const.swift
//  Learning Swift
//
//  Created by 陈林 on 20/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

let BASE_URL = "http://gank.io/api"

// 每次请求的个数
let REQUEST_NUMS = 10

// 分类与分类标签背景色
let COLOR_SORT_MAP: [Category: UIColor] = [
    .ios: UIColor(red: 51 / 255.0, green: 51 / 255.0, blue: 51 / 255.0, alpha: 1),
    .android: UIColor(red: 164 / 255.0, green: 198 / 255.0, blue: 57 / 255.0, alpha: 1),
    .frontend: UIColor(red: 226 / 255.0, green: 70 / 255.0, blue: 40 / 255.0, alpha: 1),
    .resource: UIColor(red: 37 / 255.0, green: 82 / 255.0, blue: 131 / 255.0, alpha: 1),
    .app: UIColor(red: 83 / 255.0, green: 187 / 255.0, blue: 249 / 255.0, alpha: 1),
    .recommend: UIColor(red: 239 / 255.0, green: 223 / 255.0, blue: 25 / 255.0, alpha: 1),
    .vedio: UIColor(red: 245 / 255.0, green: 166 / 255.0, blue: 35 / 255.0, alpha: 1),
    .meizi: UIColor(red: 159 / 255.0, green: 105 / 255.0, blue: 50 / 255.0, alpha: 1),
]
