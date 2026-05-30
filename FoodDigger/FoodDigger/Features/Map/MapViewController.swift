//
//  MapViewController.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/11/10.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {

    let mapView = MapView()
    let viewModel: MapViewModel
    //Marker
    var tappedMarker = GMSMarker()
    let detailBottomView = MapMarkerInfoWindow()
    var bottomConstraint: NSLayoutConstraint!

    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        mapView.googleMap.delegate = self
    }

    override func loadView() {
        super.loadView()
        view = mapView

        Location.shared.onLocationUpdate = { [weak self] coordinate in
            let position = GMSCameraPosition(target: coordinate, zoom: 15)
            self?.mapView.googleMap.animate(to: position)
        }

        Location.shared.requestLocation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomView()
        bind()
    }

    private func bind() {
        mapView.onCloseTapped = {[weak self] in
            self?.mapView.googleMap.delegate = nil
            self?.mapView.googleMap.clear()
            self?.viewModel.closeMapView()
        }

        viewModel.onRestaruantsUpdated = {[weak self] in
            DispatchQueue.main.async {
                self?.mapView.googleMap.clear()
                self?.viewModel.markers.forEach {
                    restaurant in self?.displayMarker(for: restaurant)}
            }
        }
    }

    private func setupBottomView() {
        view.addSubview(detailBottomView)
        detailBottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomConstraint = detailBottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 200)

        NSLayoutConstraint.activate([
            detailBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailBottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailBottomView.heightAnchor.constraint(equalToConstant: 200),
            bottomConstraint
        ])
    }

    private func setupMapStyle() {
        do {
            if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
                mapView.googleMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
          NSLog("One or more of the map styles failed to load. \(error)")
        }
    }

    func displayMarker(for info: RestaurantModel) {
        guard let markerImage = UIImage(named: "markerIcon") else {
            let fallbackMarker = GMSMarker()
            fallbackMarker.position = CLLocationCoordinate2D(latitude: info.lat, longitude: info.lon)
            fallbackMarker.title = info.name
            fallbackMarker.map = mapView.googleMap
            return
        }

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: info.lat,
                                                 longitude: info.lon)
        marker.icon = setImageSize(image: markerImage, scaledToSize: CGSize(width: 47, height: 55))
        marker.userData = info
        marker.map = mapView.googleMap
    }

    private func setImageSize(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
        UIGraphicsEndImageContext()
        return newImage
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let lat = position.target.latitude
        let lon = position.target.longitude
        viewModel.fetchNearbyRestaurants(lat: lat, lon: lon, category: viewModel.cuisine.lowercased())
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let restaurant = marker.userData as? RestaurantModel else { return false }

        detailBottomView.updateData(with: restaurant)

        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)

        detailBottomView.onAddTapped = {[weak self] in
            self?.viewModel.addMarker(marker: restaurant)
        }

        return true
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        bottomConstraint.constant = 200
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
