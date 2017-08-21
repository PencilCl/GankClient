//
//  GankTableViewCell.swift
//  Learning Swift
//
//  Created by 陈林 on 17/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class GankTableViewCell: UITableViewCell {
    @IBOutlet weak var dotImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var sortLabel: UILabel!
    
    var showTypeLabel = true
    var gank: Gank? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        guard let gank = gank else {
            return
        }
        
        dateLabel.text = (gank.publishedAt! as Date).toString()
        titleLabel.text = gank.desc!
        authorLabel.text = "Via: \(gank.who!)"
        if showTypeLabel {
            sortLabel.text = gank.type!
            sortLabel.backgroundColor = COLOR_SORT_MAP[Category(rawValue: gank.type!)!]!
        } else {
            sortLabel.text = ""
        }
    }
}
