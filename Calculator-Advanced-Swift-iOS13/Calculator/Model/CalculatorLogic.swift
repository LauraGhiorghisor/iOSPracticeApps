//
//  CalculatorLogic.swift
//  Calculator
//
//  Created by Laura Ghiorghisor on 20/06/2020.
//  Copyright © 2020 London App Brewery. All rights reserved.
//

import Foundation

// struct is always better than using the class
struct CalculatorLogic {
    
    private var number: Double?
    
    //    init(number: Double) {
    //        self.number = number
    //    }
    private var intermediateCalc: (n1: Double, calcMethod: String)?
    
    
    mutating func setNumber(_ number: Double) {
        self.number = number
    }
    
    mutating func calculate(symbol: String) -> Double? {
        if let n = number {
            if symbol == "+/-" {
                return n * -1
            } else if symbol == "AC" {
                return 0
            } else if symbol == "%" {
                return n/100
            }
//                else if symbol == "-" {
//                //
//            } else if symbol == "*" {
//                //
//            } else if symbol == "/" {
//                //
             else if symbol == "=" {
                return performTwoNumCalculation(n2: n)
            } else {
                self.intermediateCalc = (n1: n, calcMethod: symbol)
            }
            
            
        }
        return nil
        
    }
    
    // private methods
    private func performTwoNumCalculation(n2: Double) -> Double? {
        if let n1 = intermediateCalc?.n1, let operation = intermediateCalc?.calcMethod {
            switch operation {
            case "+":
                 return n1 + n2
            case "-":
                return n1-n2
            case "x":
                return n1*n2
            case "÷":
                return n1/n2
            default:
               fatalError("the operation passed in doesnt match any of the cases")
            }
        }
       return nil
    }
}
