//
//  MapViewModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/11/10.
//

import Foundation

protocol MapViewModelDelegate: AnyObject {
    func dismissMapView(list: [String])
}

class MapViewModel {

    weak var delegate: MapViewModelDelegate?
    let markerInfo: [MapInfoModel]
    var selectedMarkerList: [String]

    init(markerInfo: [MapInfoModel]) {
        self.markerInfo = markerInfo
        selectedMarkerList = []
    }

    func addMarker(id: String) {
        if !selectedMarkerList.contains(id) {
            selectedMarkerList.append(id)
        }
    }

    func closeMapView() {
        delegate?.dismissMapView(list: selectedMarkerList)
    }
}
