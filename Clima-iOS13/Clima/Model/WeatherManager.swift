//
//  WeatherManager.swift
//  Clima
//
//  Created by Laura Ghiorghisor on 12/06/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
// convention to be created in the same class

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error?)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=fdb8d7850fc0fc9443e9dee638b346ad&units=metric"
    
    func fetchWeather(cityName: String) {
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString)
        
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
           
           let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
           performRequest(urlString)
           
       }
    
    func performRequest(_ urlString: String) {
        
        // create URL
        
        if let url = URL(string: urlString) {
            
            // create a URLSession
            let session = URLSession(configuration: .default)
            
            // give the session a task
            let task =  session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print (error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                       //                        let weatherVC = WeatherViewController()
                       //                        weatherVC.didUpdateWeather(weather: weather)
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    } else {
                        self.delegate?.didFailWithError(error: error)
                    }
                }
            }
            
            // start the task, or : resume the task
            task.resume()
        }
        
    }
    
    
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.main.temp, decodedData.weather[0].id)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let city = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: city, temperature: temp)
            return weather
//            print(weather.conditionName)
        } catch {
           self.delegate?.didFailWithError(error: error)
            return nil
        }
}
    
    
    
}
