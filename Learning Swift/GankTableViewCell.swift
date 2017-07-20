//
//  GankTableViewCell.swift
//  Learning Swift
//
//  Created by 陈林 on 20/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class GankTableViewCell: UITableViewCell {
    
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var whoLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var gank: Gank? { didSet { updateUI() } }
    var imageURL: URL?
    
    private func updateUI() {
        photoImageView.image = nil
        descriptionLabel.text = gank?.desc
        createdLabel.text = gank?.created
        whoLabel.text = gank?.who
        if gank?.image == nil {
            photoImageView.isHidden = true
        } else {
            photoImageView.isHidden = false
            imageURL = URL(string: (gank!.image)!)
            
            if imageURL == nil {
                return
            }
            
            DispatchQueue.global().async { [weak self] in
                let url = (self?.imageURL)!
                if let urlContents = try? Data(contentsOf: url) {
                    let image = UIImage(data: urlContents)
                    DispatchQueue.main.async { [weak self] in
                        if url == self?.imageURL {
                            self?.photoImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
}
