//
//  CLImageView.swift
//  Learning Swift
//
//  Created by 陈林 on 21/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

public class CLImageView: UIImageView {
    
    var imageUrl = ""
    
    func setImage(url: String, _ completion: @escaping () -> Void) {
        if imageUrl == url {
            return
        }
        image = nil
        imageUrl = url
        Alamofire.request(url)
            .responseData { [weak self] response in
                guard self?.imageUrl == url else { return }
                
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
