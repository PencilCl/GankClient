//
//  ViewController.swift
//  Learning Swift
//
//  Created by Chen lin on 15/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    
    var isTyping: Bool = false
    var operation: String?
    var lastOperand:  Double = 0
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        var current: String
        if isTyping {
            current = display.text! + digit
        } else {
            current = digit
            isTyping = true
        }
        
        display.text = current
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if let methodSymbol = sender.currentTitle {
            let displayValue = Double(display.text!)!
            
            switch methodSymbol {
            case "π":
                lastOperand = Double.pi
            case "√":
                lastOperand = sqrt(displayValue)
            case "cos":
                lastOperand = cos(displayValue)
            case "±":
                lastOperand = -displayValue
            case "=":
                lastOperand = calculate(with: displayValue)
            default:
                operation = methodSymbol
            }
            isTyping = false
            display.text = String(lastOperand)
        }
    }
    
    private func calculate(with secondOperand: Double) -> Double {
        if let op = operation {
            operation = nil
            switch op {
            case "+":
                return lastOperand + secondOperand
            case "-":
                return lastOperand - secondOperand
            case "×":
                return lastOperand * secondOperand
            case "÷":
                return lastOperand / secondOperand
            default:
                break
            }
        }
        return lastOperand
    }

}

