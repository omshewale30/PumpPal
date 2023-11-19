//
//  LocationViewModel.swift
//  PumpPal
//
//  Created by Om Shewale on 11/17/23.
//

import Foundation
import CoreLocation


class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    private var locationManager = CLLocationManager()
    private var coordinate:CLLocationCoordinate2D = .init()

    @Published var userLocation: CLLocation?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location
            print("got user's location")
        }
    }
    
    func getCoordinate(addressString: String) {  //this function is used to find coordinates of the location
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    self.coordinate = location.coordinate
                }
            } else {
                print("error getting the coordinates \(error?.localizedDescription)")
            }
        }
    }
}

