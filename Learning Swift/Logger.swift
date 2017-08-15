//
//  Logger.swift
//  Learning Swift
//
//  Created by 陈林 on 15/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import XCGLogger

let log:XCGLogger = {
    let log = XCGLogger.default
    log.identifier = "Gank"
    
    return log
}()

