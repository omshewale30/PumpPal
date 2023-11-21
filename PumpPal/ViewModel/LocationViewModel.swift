//
//  LocationViewModel.swift
//  PumpPal
//
//  Created by Om Shewale on 11/17/23.
//

import Foundation
import CoreLocation


class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    

    private var locationManager: CLLocationManager?
    
    @Published var userLocation: CLLocation?
    
    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location
            stopUpdatingLocation()
            print("Got user's location")
        }
    }
    
    func getCoordinate(addressString: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { [weak self] (placemarks, error) in
            if error == nil, let placemark = placemarks?.first, let location = placemark.location {
                self?.userLocation = location
                print("Got coordinates")
            } else {
                print("Error getting the coordinates: \(error?.localizedDescription ?? "")")
            }
        }
    }
}

