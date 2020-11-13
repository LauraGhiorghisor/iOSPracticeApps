//
//  ViewController.swift
//  Dicee-iOS13
//
//  Created by Angela Yu on 11/06/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var diceIV1: UIImageView!
    
    @IBOutlet weak var diceIV2: UIImageView!
    
    @IBOutlet weak var rollBtn: UIButton!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            
            // this is an image literal
    //        diceIV1.image = #imageLiteral(resourceName: "DiceSix")
//            rollBtn.frame = CGRect
            rollBtn.layer.cornerRadius = 10
            
        }

    
    @IBAction func diceRollPressed(_ sender: Any) {
  
        
//        let number1 = (Int.random(in: 0 ..< 6) + 1)
//        let number2 = Int.random(in: 0 ..< 6) + 1
//        var strEquivalent1: String = ""
//        var strEquivalent2: String = ""
//
//        switch number1 {
//        case 1:
//            strEquivalent1 = "One"
//        case 2:
//            strEquivalent1 = "Two"
//        case 3:
//             strEquivalent1 = "Three"
//        case 4:
//             strEquivalent1 = "Four"
//        case 5:
//             strEquivalent1 = "Five"
//        case 6:
//             strEquivalent1 = "Six"
//        default:
//            print("Not ok: \(number1)")
//        }
//        switch number2 {
//        case 1:
//            strEquivalent2 = "One"
//        case 2:
//            strEquivalent2 = "Two"
//        case 3:
//             strEquivalent2 = "Three"
//        case 4:
//             strEquivalent2 = "Four"
//        case 5:
//             strEquivalent2 = "Five"
//        case 6:
//             strEquivalent2 = "Six"
//        default:
//            print("Not ok: \(number2)")
//        }
//
//        diceIV1.image = UIImage(named: "Dice\(strEquivalent1)")
//        diceIV2.image = UIImage(named: "Dice\(strEquivalent2)")
        
        
        let myImg: [UIImage] = [#imageLiteral(resourceName: "DiceOne"), #imageLiteral(resourceName: "DiceTwo"),#imageLiteral(resourceName: "DiceThree"),#imageLiteral(resourceName: "DiceFour"),#imageLiteral(resourceName: "DiceFive"),#imageLiteral(resourceName: "DiceSix")]
//        diceIV1.image = myImg[Int.random(in: 0...5)]
//        diceIV2.image = myImg[Int.random(in: 0...5)]

        diceIV1.image = myImg.randomElement()
        diceIV2.image = myImg.randomElement()
        
    }
    

}

