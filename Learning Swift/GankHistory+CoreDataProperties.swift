//
//  GankHistory+CoreDataProperties.swift
//  Learning Swift
//
//  Created by 陈林 on 20/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import CoreData


extension GankHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GankHistory> {
        return NSFetchRequest<GankHistory>(entityName: "GankHistory")
    }

    @NSManaged public var date: NSDate?

}
