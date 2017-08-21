//
//  DateExtension.swift
//  Learning Swift
//
//  Created by 陈林 on 20/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation

extension Date {
    func toString(format: String = "YYYY-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    static func fromString(_ string: String, format: String = "YYYY-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: string)
    }
}
