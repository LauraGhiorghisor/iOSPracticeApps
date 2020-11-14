//
//  LocationSearchTable.swift
//  SearchMap
//
//  Created by Laura Ghiorghisor on 30/06/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.

import UIKit
import MapKit

class LocationSearchTable : UITableViewController {
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    var spanValue: CLLocationDegrees = 0.05
    var handleMapSearchDelegate:HandleMapSearch? = nil

    override func viewDidLoad() {
        //
    }
}


extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchBarText = searchController.searchBar.text else {return}
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView!.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            for place in self.matchingItems {
                print(place.placemark as Any, " \n")
            }
            if self.matchingItems.count > 0{
                let safeLocation = self.matchingItems[0].placemark
                let location = CLLocationCoordinate2D(latitude: safeLocation.coordinate.latitude, longitude: safeLocation.coordinate.longitude)
                let span = MKCoordinateSpan(latitudeDelta: self.spanValue, longitudeDelta: self.spanValue)
                let region = MKCoordinateRegion(center: location, span: span)
                self.mapView!.setRegion(region, animated: true)
                //            self.spanValue = 10
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print(self.matchingItems.count)
        }
        
       
        
  //MARK: - Re-center map - must improve
        
    }
}

//MARK: - Data Source
extension LocationSearchTable {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("the source data methods are being called")
        return matchingItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("the source data methods are being called")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem)
        cell.backgroundColor = UIColor.red
        return cell
        
    }
    
    func parseAddress(_ selectedItem: MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

//MARK: - UITableViewDelegate

extension LocationSearchTable {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
        }
    }

