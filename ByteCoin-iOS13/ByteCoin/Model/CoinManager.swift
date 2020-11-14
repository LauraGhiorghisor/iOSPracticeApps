//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didGetData(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error?)
    
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8E1F749B-5B9F-46D5-8ADD-372BC463B7D8"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
//https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=8E1F749B-5B9F-46D5-8ADD-372BC463B7D8
     
    var delegate: CoinManagerDelegate?
  
    func getCoinPrice(for currency: String) {
//        print(currency)
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        performRequest(urlString)
        
        
    }
    
    func performRequest(_ url: String) {
        print ("perfor m req")
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                self.delegate?.didFailWithError(error: error)
                return
                }
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        print("i am calling the didget")
                       self.delegate?.didGetData(self, coin: coin)
                          print("i have done  calling the didget")
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CoinModel?{
        print("i am parsing")
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            print()
            let bitcoinValue = decodedData.rate
//            print(decodedData.rate)
            let bitcoin = CoinModel(bitcoin: bitcoinValue, currency: decodedData.asset_id_quote)
            return bitcoin
        }
        catch {
            self.delegate?.didFailWithError(error: error)
                       return nil
        }
    }
}
