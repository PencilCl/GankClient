//
//  HeaderTableViewCell.swift
//  Learning Swift
//
//  Created by 陈林 on 16/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    var title: String? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private func updateUI() {
        if let title = title {
            titleLabel.text = title
        }
    }

}
