//
//  EmotionsViewController.swift
//  Learning Swift
//
//  Created by Chen lin on 17/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destination = segue.destination
        if let navigationController = destination as? UINavigationController {
            destination = navigationController.visibleViewController ?? destination
        }
        if let faceViewController = destination as? FaceViewController,
            let identifier = segue.identifier,
            let expression = expressions[identifier] {
            faceViewController.expression = expression
            faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
        }
    }
    
    private let expressions: Dictionary<String, FacialExpression> = [
        "sad" : FacialExpression(eyes: .closed, mouth: .frown),
        "happy" : FacialExpression(eyes: .open, mouth: .smile),
        "worried" : FacialExpression(eyes: .open, mouth: .smirk)
    ]

}
