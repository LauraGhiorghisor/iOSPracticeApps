//
//  ViewController.swift
//  Tipsy
//
//  Created by Angela Yu on 09/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var billTextField: UITextField!
    
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var tenButton: UIButton!
    @IBOutlet weak var twentyButton: UIButton!
    
    @IBOutlet weak var splitNumberLabel: UILabel!
    
    var tip: Double = 0.2
    var people: Int = 2
    var billTotal = 0.0
    var finalTotal = "0.0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//          billTextField.becomeFirstResponder()
        billTextField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
         billTextField.becomeFirstResponder()
    }
    
    @IBAction func tipChanged(_ sender: UIButton) {
        
        // what does this do
//        billTextField.endEditing(true)
        billTextField.resignFirstResponder()
        
        zeroButton.isSelected = false
        tenButton.isSelected = false
        twentyButton.isSelected = false
        sender.isSelected = true
        
        if sender.currentTitle == "0%" {
            tip = 0
        } else if sender.currentTitle == "10%" {
            tip = 0.1
        } else {
            tip = 0.2
        }
        
//        let buttonTitle = sender.currentTitle!
//               let buttonTitleMinusPercentSign =  String(buttonTitle.dropLast())
//               let buttonTitleAsANumber = Double(buttonTitleMinusPercentSign)!
//               tip = buttonTitleAsANumber / 100

        
    }
    
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        billTextField.resignFirstResponder()
        splitNumberLabel.text = String(format: "%.0f", sender.value)
        people = Int(sender.value)
    }
    
    
    @IBAction func calculatePressed(_ sender: UIButton) {
//         billTextField.endEditing(true)
        billTextField.resignFirstResponder()
        let money =  Double(billTextField.text!) ?? 0.0
        finalTotal = String(format: "%.2f", money*(1 + tip)/Double(people))
        
        print(finalTotal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goToResults" {
            let controller = segue.destination as! ResultsViewController
                controller.people = people
                controller.total = finalTotal
                controller.tip = Int(tip*100)
                
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        billTextField.resignFirstResponder()
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        billTextField.resignFirstResponder()
               let money =  Double(billTextField.text!) ?? 0.0
               finalTotal = String(format: "%.2f", money*(1 + tip)/Double(people))
               print(finalTotal)
        performSegue(withIdentifier: "goToResults", sender: self)
        return true
    }
}


