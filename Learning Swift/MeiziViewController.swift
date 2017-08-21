//
//  MeiziViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 18/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class MeiziViewController: UIViewController {
    var images = [SKPhoto]()
    var ganks = [Gank]()
    
    var loadMore = true
    var isFetching = false
    var page = 1
    
    func showImage(_ index: Int) {
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(index)
        present(browser, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate func fetchData() {
        if !loadMore || isFetching {
            return
        }
        isFetching = true
        
        GankService.fetchGanksByCategory(category: .meizi, page: page) { [weak self] (ganks, error) in
            self?.isFetching = false
            if let error = error {
                log.error("fetch meizi error \(error)")
                return
            }
            
            if ganks.count < REQUEST_NUMS {
                self?.loadMore = false
            }
            
            self?.ganks += ganks
            self?.images += ganks.map { SKPhoto.photoWithImageURL($0.url!) }
            self?.page += 1
            self?.collectionView.reloadData()
        }
    }
    
    deinit {
        log.debug("deinit: \(type(of: self))")
    }
}

extension MeiziViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ganks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as! MeiziCollectionViewCell
        let gank = ganks[indexPath.row]
        cell.gank = gank
        
        let image = images[indexPath.row].underlyingImage
        if image != nil {
            // 图片存在直接设置image
            cell.imageView.image = image
        } else {
            // 下载好图片则更新images数组
            cell.imageView.setImage(url: gank.url!) { [weak self] in
                if let image = cell.imageView.image {
                    self?.images[indexPath.row] = SKPhoto.photoWithImage(image)
                }
            }
        }
        
        if indexPath.row == ganks.count - 1 {
            fetchData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (SCREEN_WIDTH - 10) / 2
        return CGSize(width: width, height: width + 27)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showImage(indexPath.row)
    }
}
