//
//  MapViewController.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/11/10.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    let mapView = MapView()
    let viewModel: MapViewModel
    let locationManager = CLLocationManager()
    //Marker
    var tappedMarker = GMSMarker()
    var infoWindow = MapMarkerInfoWindow()

    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        mapView.googleMap.delegate = self
        mapView.delegate = self
    }

    override func loadView() {
        super.loadView()
        view = mapView

        //WIP: show current location
        let position = CLLocationCoordinate2D(latitude: 37.786882, longitude: -122.399972)
        mapView.googleMap.camera = GMSCameraPosition(target: position, zoom: 15)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        displayMarker()
    }

    func displayMarker() {
        guard let markerImage = UIImage(named: "markerIcon") else { return }
        for info in viewModel.markerInfo {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: info.latitude,
                                                     longitude: info.longitude)
            marker.icon = setImageSize(image: markerImage, scaledToSize: CGSize(width: 47, height: 55))
            marker.map = mapView.googleMap
            marker.userData = info
        }
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

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let tappedMarkerInfo = marker.userData as? MapInfoModel else {
            return false
        }

        tappedMarker = marker
        infoWindow.removeFromSuperview()
        infoWindow = MapMarkerInfoWindow()
        infoWindow.nameLabel.text = tappedMarkerInfo.name
        infoWindow.addButton.addTarget(self, action: #selector(pressAddButton), for: .touchUpInside)
        infoWindow.center = mapView.projection.point(for: marker.position)
        infoWindow.center.x += 70
        infoWindow.center.y -= 70

        self.view.addSubview(infoWindow, anchors: [.centerX(0), .centerY(0), .width(200), .height(54)])
        return false
    }

    @objc
    func pressAddButton() {
        guard let tappedMarkerInfo = tappedMarker.userData as? MapInfoModel else {
            return
        }
        viewModel.addMarker(id: tappedMarkerInfo.id)
    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if (tappedMarker.userData != nil){
            let location = CLLocationCoordinate2D(latitude: tappedMarker.position.latitude,
                                                  longitude: tappedMarker.position.longitude)
            infoWindow.center = mapView.projection.point(for: location)
            infoWindow.center.x += 70
            infoWindow.center.y -= 70
        }
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
    }
}

extension MapViewController: MapViewDelegate {
    func didPressCloseButton(sender: UIButton) {
        viewModel.closeMapView()
    }
}
