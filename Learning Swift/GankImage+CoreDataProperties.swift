//
//  GankImage+CoreDataProperties.swift
//  Learning Swift
//
//  Created by 陈林 on 20/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import CoreData


extension GankImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GankImage> {
        return NSFetchRequest<GankImage>(entityName: "GankImage")
    }

    @NSManaged public var url: String?
    @NSManaged public var gank: Gank?

}
