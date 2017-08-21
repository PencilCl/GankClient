//
//  PhotoBrowser.swift
//  Learning Swift
//
//  Created by 陈林 on 21/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import SKPhotoBrowser

public class PhotoBrowser {
    
    class func photoBrowserController(url: String) -> SKPhotoBrowser {
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL(url)
        photo.shouldCachePhotoURLImage = false
        images.append(photo)
        
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        return browser
    }
    
}
