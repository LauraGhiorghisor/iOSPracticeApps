//
//  WeatherData.swift
//  Clima
//
//  Created by Laura Ghiorghisor on 12/06/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation


struct WeatherData: Decodable {
    
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
//    let description: String
}
