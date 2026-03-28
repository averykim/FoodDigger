//
//  LocationManager.swift
//  FoodDigger
//
//  Created by JihyeKim on 3/26/26.
//

import Foundation
import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {
    static let shared = Location()

    private let manager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?

    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocation = location.coordinate
        onLocationUpdate?(location.coordinate)
        manager.stopUpdatingLocation()

    }

}
