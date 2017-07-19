//
//  ImageViewController.swift
//  Learning Swift
//
//  Created by 陈林 on 18/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.maximumZoomScale = 1.0
            scrollView.minimumZoomScale = 0.03
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }

    var imageUrl: URL? {
        didSet {
            image = nil
            fetchImage()
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    private func fetchImage() {
        if let url = imageUrl {
            spinner?.startAnimating()
            DispatchQueue.global().async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let data = urlContents, url == self?.imageUrl {
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    fileprivate let imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }

}

extension ImageViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
