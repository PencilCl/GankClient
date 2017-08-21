//
//  MeiziCollectionViewCell.swift
//  Learning Swift
//
//  Created by 陈林 on 18/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class MeiziCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: CLImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var gank: Gank? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let gank = gank {
            dateLabel.text = (gank.publishedAt! as Date).toString()
        }
    }
}
