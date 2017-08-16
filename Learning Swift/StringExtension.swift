//
//  StringExtension.swift
//  Learning Swift
//
//  Created by 陈林 on 16/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation

extension String {
    public var toChineseMonth: String {
        switch self {
        case "01":
            return "一月"
        case "02":
            return "二月"
        case "03":
            return "三月"
        case "04":
            return "四月"
        case "05":
            return "五月"
        case "06":
            return "六月"
        case "07":
            return "七月"
        case "08":
            return "八月"
        case "09":
            return "九月"
        case "10":
            return "十月"
        case "11":
            return "十一月"
        case "12":
            return "十二月"
        default:
            return ""
        }
    }
}
