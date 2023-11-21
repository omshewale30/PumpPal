//
//  LocationView.swift
//  PumpPal
//
//  Created by Om Shewale on 10/21/23.
//

import SwiftUI
import MapKit

struct MapItemWrapper: Identifiable {
    let id: MKPlacemark
    let mapItem: MKMapItem
}


struct LocationView: View {
    @State private var foodItems: [FoodItemEntity] = []
    @StateObject var coreVM=CoreDataViewModel()
    
    @State private var annotations: [MapItemWrapper] = []
    @EnvironmentObject var userStore: UserStore
    @State private var region: MKCoordinateRegion = .init()


    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: annotations) { annotation in
            MapPin(coordinate: annotation.id.coordinate, tint: .blue)
        }
        .onAppear {
            foodItems=coreVM.fetchFoodHistory(forUser: userStore.loggedInUser!)
            updateAnnotations()
            
        }
    }
    private func updateAnnotations() {

        annotations = foodItems.map { foodItem in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: foodItem.latitude, longitude: foodItem.longitude)

            return MapItemWrapper(id: MKPlacemark(coordinate: annotation.coordinate), mapItem: MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate)))
        }

        guard let firstFoodItem = foodItems.first else {
            region = .init()
            return
        }

        var minLatitude = firstFoodItem.latitude
        var maxLatitude = firstFoodItem.latitude
        var minLongitude = firstFoodItem.longitude
        var maxLongitude = firstFoodItem.longitude

        for foodItem in foodItems {
            minLatitude = min(minLatitude, foodItem.latitude)
            maxLatitude = max(maxLatitude, foodItem.latitude)
            minLongitude = min(minLongitude, foodItem.longitude)
            maxLongitude = max(maxLongitude, foodItem.longitude)
        }

        let center = CLLocationCoordinate2D(latitude: (minLatitude + maxLatitude) / 2, longitude: (minLongitude + maxLongitude) / 2)
        let span = MKCoordinateSpan(latitudeDelta: maxLatitude - minLatitude, longitudeDelta: maxLongitude - minLongitude)

        region = MKCoordinateRegion(center: center, span: span)
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
