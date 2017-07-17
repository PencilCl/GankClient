//
//  ViewController.swift
//  Learning Swift
//
//  Created by Chen lin on 15/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            let handler = #selector(faceView.changedScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: handler)
            faceView.addGestureRecognizer(pinchRecognizer)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(beReactingTo:)))
            faceView.addGestureRecognizer(tapRecognizer)
            let swipeUpRegconizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHapppiness))
            swipeUpRegconizer.direction = .up
            faceView.addGestureRecognizer(swipeUpRegconizer)
            let swipeDownRegconizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseSadness))
            swipeDownRegconizer.direction = .down
            faceView.addGestureRecognizer(swipeDownRegconizer)
            updateUI()
        }
    }
    
    func increaseHapppiness() {
        expression = expression.happier
    }
    
    func increaseSadness() {
        expression = expression.sadder
    }
    
    func toggleEyes(beReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            expression = FacialExpression(eyes: expression.eyes == .open ? .closed : .open, mouth: expression.mouth)
        }
    }
    
    var expression = FacialExpression(eyes: .open, mouth: .smile) {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        switch expression.eyes {
        case .open:
            faceView?.eyeOpen = true
        case .closed:
            faceView?.eyeOpen = false
        case .squinting:
            faceView?.eyeOpen = false
        }
        
        faceView?.mouthCurve = mouthCurvatures[expression.mouth]!
    }
    
    let mouthCurvatures = [FacialExpression.Mouth.frown:-1.0, .smirk: -0.5, .neutral: 0, .grin: 0.5, .smile: 1.0]

}

