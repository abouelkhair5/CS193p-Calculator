//
//  ViewController.swift
//  Calculator
//
//  Created by Amr Abouelkhair on 2017-09-30.
//  Copyright © 2017 Amr Abouelkhair. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    private var brain = CalculatorBrain()
    
    var userInTheMiddleOfTyping = false
    
    var floatingPointUsed = false
    
    var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            if newValue == 0.0 {
                display.text = "0"
            }
            else {
                display.text = String(newValue)
            }
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "." {
            if !floatingPointUsed{
                let textCurrentlyInDisplay = display.text!
                display.text = textCurrentlyInDisplay + digit
                floatingPointUsed = true
                userInTheMiddleOfTyping = true
            }
        }
        else if userInTheMiddleOfTyping{
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }
        else if digit != "0" { // to avoid having leading zeroes
            display.text = digit
            userInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func reset() {
        displayValue = 0
        userInTheMiddleOfTyping = false
        brain.reset()
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if(userInTheMiddleOfTyping) {
            brain.setOperand(displayValue)
            userInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        print(brain.description)
        if let result = brain.result {
            displayValue = result
        }
        
    }
    
}


