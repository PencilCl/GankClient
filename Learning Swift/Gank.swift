//
//  Gank.swift
//  Learning Swift
//
//  Created by 陈林 on 20/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation

class Gank: NSObject {
    public var desc: String
    public var created: String
    public var image: String?
    public var who: String
    
    init(description desc: String, created: String, image: String?, who: String) {
        self.desc = desc
        self.created = created
        self.image = image == nil ? nil : image! + "?imageView2/0/w/358"
        self.who = who
    }
    
    override var description: String {
        return "\nDescription: \(desc);\nCreated: \(created);\nImages: \(image ?? "nil");\nWho: \(who);\n"
    }

}
