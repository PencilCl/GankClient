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
        ["category": Category.all, "icon": #imageLiteral(resourceName: "all")],
        ["category": Category.ios, "icon": #imageLiteral(resourceName: "ios")],
        ["category": Category.android, "icon": #imageLiteral(resourceName: "android")],
        ["category": Category.frontend, "icon": #imageLiteral(resourceName: "frontend")],
        ["category": Category.resource, "icon": #imageLiteral(resourceName: "resouce")],
        ["category": Category.app, "icon": #imageLiteral(resourceName: "app")],
        ["category": Category.recommend, "icon": #imageLiteral(resourceName: "recommend")],
        ["category": Category.vedio, "icon": #imageLiteral(resourceName: "vedio")],
        ["category": Category.meizi, "icon": #imageLiteral(resourceName: "meizi")],
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desVC = segue.destination as? GankListViewController,
            let title = sender as? Category {
            desVC.title = title.rawValue
        }
    }

}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        cell.iconImageView.image = categorys[indexPath.row]["icon"] as? UIImage
        cell.categoryLabel.text = (categorys[indexPath.row]["category"] as? Category)?.rawValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gankList", sender: categorys[indexPath.row]["category"])
    }
    
}

