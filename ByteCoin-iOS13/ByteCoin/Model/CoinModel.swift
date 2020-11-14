//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Laura Ghiorghisor on 13/06/2020.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel  {

    let bitcoin: Double

    var bitcoinString: String {
        String(format: "%.2f", bitcoin)
    }

    let currency: String
}
