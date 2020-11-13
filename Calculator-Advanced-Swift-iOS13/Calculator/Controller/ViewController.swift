//
//  ViewController.swift
//  Calculator
//
//  Created by Angela Yu on 10/09/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var calculator = CalculatorLogic()
    
    @IBOutlet weak var displayLabel: UILabel!
    private var isFinishedTypingNumber = true
    private var displayValue: Double {
        get {
            guard let currentDisplay = Double(displayLabel.text!) else {
                fatalError("Cannot convert to double")
            }
            return currentDisplay
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
    
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        
        // let number = Double(displayLabel.text!)!
        // this is allowed because there will always  be a number .. kind of.
        // also, use nil coalesfing operator and do  let number = Double(displayLabel.text!) ?? 0 - kinda good...
        // preferred way: make the app crash:
        
        isFinishedTypingNumber = true
        calculator.setNumber(displayValue)
        if let operation = sender.currentTitle {
            guard let result = calculator.calculate(symbol: operation) else {
                fatalError("RESULT of calculation is nil")
            }
            displayValue = result
        }
        
        
    }
    
    
    @IBAction func numButtonPressed(_ sender: UIButton) {
        
        //What should happen when a number is entered into the keypad
        if let curNum = sender.currentTitle {
            if isFinishedTypingNumber {
                displayLabel.text = curNum
                isFinishedTypingNumber = false
            } else {
                if curNum == "." {
                    
                    // isInt bevomes a bool based on the == operation
                    let isInt = floor(Double((displayValue))) == Double(displayValue)
                    if !isInt {
                        return
                    }
                }
                displayLabel.text = displayLabel.text! + curNum
                
            }
        }
    }
    
}

