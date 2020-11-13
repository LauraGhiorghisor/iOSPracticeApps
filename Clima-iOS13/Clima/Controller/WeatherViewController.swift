//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        weatherManager.delegate = self
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        // alternatively, use startupdatinglocation - for constant updates
          
    }
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
         locationManager.requestLocation()
//        if let city = searchTextField.text {
//            weatherManager.fetchWeather(cityName: city.replacingOccurrences(of: " ", with: "+"))
//        }
    }
    
}




//MARK: - Location delegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            // this allows the location to be retrieved again. 
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error)
    }
    
    
    
    
}

//MARK: - Text field delegate

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
        //endeditting
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Please enter a place name"
            return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.placeholder = "Search"
        searchTextField.resignFirstResponder()
        
    }
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city.replacingOccurrences(of: " ", with: "+"))
        }
        
        searchTextField.text = ""
        
    }
    
}
//MARK: - Weather manager delegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text =  weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            
        }
        // ERROR: if the execution is inside A CLOSURE, it it waiting on it. must call dispatch queue
        //        print(weather.temperatureString, weather.conditionName)
    }
    func didFailWithError(error: Error?) {
        print(error ?? "")
        // test by turning off wi fi etc.
    }
    
    
}

