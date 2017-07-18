//
//  ImageViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 18/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!

    private var imageUrl: URL? {
        didSet {
            image = nil
            fetchImage()
        }
    }
    
    private func fetchImage() {
        if let url = imageUrl {
            let urlContents = try? Data(contentsOf: url)
            if let data = urlContents {
                image = UIImage(data: data)
            }
        } else {
            print("url is nil")
        }
    }
    
    fileprivate let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.maximumZoomScale = 1.0
        scrollView.minimumZoomScale = 0.03
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        imageUrl = URL(string: "http://www.tensorfly.cn/images/hero-bg@2x.jpg")
    }
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView.contentSize = imageView.frame.size
        }
    }

}

extension ImageViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
