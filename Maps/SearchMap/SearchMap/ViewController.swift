//
//  ViewController.swift
//  SearchMap
//
//  Created by Laura Ghiorghisor on 29/06/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//


//<a href="https://www.vecteezy.com/free-vector/car">Car Vectors by Vecteezy</a>
//<a href="https://www.vecteezy.com/free-vector/heart-shape">Heart Shape Vectors by Vecteezy</a>

import UIKit
import MapKit

// define our own protocol
protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class ViewController : UIViewController {
    
    var resultSearchController:UISearchController? = nil
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var matchingItems: [MKMapItem] = []
    
    var selectedPin: MKPlacemark? = nil
        var spanValue: CLLocationDegrees = 0.05
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Creates the view controller with the specified identifier and initializes it with the data from the storyboard.
        let locationSearchTable = storyboard?.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable

        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        //        resultSearchController?.automaticallyShowsCancelButton = false
        resultSearchController?.showsSearchResultsController = true
        //        resultSearchController?.automaticallyShowsScopeBar = true
        navigationItem.titleView = resultSearchController?.searchBar
        //        navigationItem.searchController = resultSearchController
        //???
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        
        //delegate for annotations
        locationSearchTable.handleMapSearchDelegate = self
        
        
        
        
    }
}

extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let safeLocation = locations.first {
            //            // why is it first?????????
            let location = CLLocationCoordinate2D(latitude: safeLocation.coordinate.latitude, longitude: safeLocation.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}

//MARK: - Handle map search

extension ViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        // clear existing pins
//         mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality, let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: spanValue, longitudeDelta: spanValue)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

//MARK: - Map View Delegate - handles clicking on annotations
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("clicking the annotation")
        if annotation is MKUserLocation {
                   //return nil so map view draws "blue dot" for standard user location
                   return nil
               }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
//        Although this is beyond the scope of this tutorial, you can also use a custom icon instead of the default pin.
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(self.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        let addButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        addButton.setBackgroundImage(UIImage(named: "heart"), for: .normal)
        addButton.addTarget(self, action: #selector(self.addToFavourites), for: .touchUpInside)
        pinView?.rightCalloutAccessoryView = addButton
        return pinView
    }
    
//MARK: - Rewrite to do other stuff such as add to ur list of objecties etc.
     @objc func getDirections () {
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    //MARK: - Add to favourites implementation
    @objc func addToFavourites() {
         if let selectedPin = selectedPin {
        print("added to favourites")
        }
    }
}
