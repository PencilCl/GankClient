//
//  CategoryViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 15/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    let categorys = [
        ["category": "All", "icon": #imageLiteral(resourceName: "all")],
        ["category": "iOS", "icon": #imageLiteral(resourceName: "ios")],
        ["category": "Android", "icon": #imageLiteral(resourceName: "android")],
        ["category": "前端", "icon": #imageLiteral(resourceName: "frontend")],
        ["category": "拓展资源", "icon": #imageLiteral(resourceName: "resouce")],
        ["category": "App", "icon": #imageLiteral(resourceName: "app")],
        ["category": "瞎推荐", "icon": #imageLiteral(resourceName: "recommend")],
        ["category": "休息视频", "icon": #imageLiteral(resourceName: "vedio")],
        ["category": "福利", "icon": #imageLiteral(resourceName: "meizi")],
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        cell.iconImageView.image = categorys[indexPath.row]["icon"] as? UIImage
        cell.categoryLabel.text = categorys[indexPath.row]["category"] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        log.debug("selected category: \(categorys[indexPath.row]["category"] as! String)")
    }
    
}

