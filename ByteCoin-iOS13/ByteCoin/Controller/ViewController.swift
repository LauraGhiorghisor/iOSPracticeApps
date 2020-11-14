//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    


    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}

//MARK: - Coin manager delegate
extension ViewController:  UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("i have picked")
        coinManager.getCoinPrice(for:  coinManager.currencyArray[row])
       print (coinManager.currencyArray[row])
    }
}

    //MARK: - Delegate
extension ViewController: CoinManagerDelegate  {
    
    func didGetData(_ coinManager: CoinManager, coin: CoinModel) {
        
         print("i got the data")
        DispatchQueue.main.async {
            print("i got the data")
//            print(coin.bitcoinString)
            self.bitcoinLabel.text = coin.bitcoinString
            self.currencyLabel.text = coin.currency
        }
       
    }
    
    func didFailWithError(error: Error?) {
        print(error ?? "")
        print("wtf")
    }
    
    
}
      


