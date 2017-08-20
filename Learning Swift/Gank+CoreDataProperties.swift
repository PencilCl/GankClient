//
//  Gank+CoreDataProperties.swift
//  Learning Swift
//
//  Created by 陈林 on 20/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import CoreData


extension Gank {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gank> {
        return NSFetchRequest<Gank>(entityName: "Gank")
    }

    @NSManaged public var id: String?
    @NSManaged public var createAt: NSDate?
    @NSManaged public var desc: String?
    @NSManaged public var publishedAt: NSDate?
    @NSManaged public var type: String?
    @NSManaged public var url: String?
    @NSManaged public var used: Bool
    @NSManaged public var who: String?
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for images
extension Gank {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: GankImage)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: GankImage)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}
