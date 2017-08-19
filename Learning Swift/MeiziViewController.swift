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
    var images = [
        SKPhoto.photoWithImageURL("https://i.stack.imgur.com/qdDEU.png"),
        SKPhoto.photoWithImageURL("https://i.stack.imgur.com/UEzO6.png"),
        SKPhoto.photoWithImageURL("https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Cat_Golden_Chinchilla.jpg/200px-Cat_Golden_Chinchilla.jpg"),
        SKPhoto.photoWithImageURL("http://www.tianqi.com/upload/article/15-06-10/XzKG_150610052612_1.jpg")
    ]
    
    func showImage(_ index: Int) {
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(index)
        present(browser, animated: true, completion: nil)
    }
    
}

extension MeiziViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 10) / 2
        return CGSize(width: width, height: width + 27)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showImage(indexPath.row)
    }
}
