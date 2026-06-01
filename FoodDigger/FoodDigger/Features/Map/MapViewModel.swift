//
//  MapViewModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/11/10.
//

import Foundation

class MapViewModel {

    var dismissMapView: (([RestaurantModel]) -> Void)?
    var onRestaruantsUpdated: (() ->  Void)?

    var markers: [RestaurantModel] = [] {
        didSet {
            onRestaruantsUpdated?()
        }
    }

    var selectedMarkers: [RestaurantModel]

    let cuisine: String

    init(_ cuisine: String) {
        self.cuisine = cuisine
        selectedMarkers = []
    }

    func fetchNearbyRestaurants(lat: Double, lon: Double, category: String) {
        Task {
            do {
                let fetched = try await RestaurantService().getRestaurants(lat: lat, lon: lon, category: category)
                self.markers = fetched
            } catch {
                print("Error to load map data: \(error)")
            }
        }
    }

    func addMarker(marker: RestaurantModel) {
        if !selectedMarkers.contains(where: {$0.id == marker.id}) {
            selectedMarkers.append(marker)
        }
    }

    func closeMapView() {
        dismissMapView?(selectedMarkers)
    }
}
