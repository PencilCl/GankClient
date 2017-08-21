//
//  UIImageExtension.swift
//  Learning Swift
//
//  Created by 陈林 on 20/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

extension UIImageView {
    func setImage(url: String, _ completion: @escaping () -> Void) {
        Alamofire.request(url)
            .responseData { [weak self] response in
                switch response.result {
                case .success(let value):
                    let image = UIImage(data: value)
                    DispatchQueue.main.async {
                        self?.image = image
                        completion()
                    }
                case .failure(_):
                    log.debug("fetch image failed")
                    break
                }
        }
    }
}
