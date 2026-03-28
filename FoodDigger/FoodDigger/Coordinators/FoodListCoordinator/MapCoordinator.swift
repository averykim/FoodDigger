//
//  MapCoordinator.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/11/10.
//

import UIKit

protocol MapCoordinatorDelegate: AnyObject {
    func mapCoordinatorDidFinish(list: [String])
}

class MapCoordinator: Coordinator {

    weak var delegate: MapCoordinatorDelegate?

    func start(info: [MapInfoModel]) {
        let mapViewModel = MapViewModel(markerInfo: info)
        let mapViewController  = MapViewController(viewModel: mapViewModel)
        mapViewModel.delegate = self
        mapViewController.modalPresentationStyle = .fullScreen
        mapViewController.modalTransitionStyle = .crossDissolve
        navigationController.present(mapViewController, animated: false, completion: nil)
    }
}

extension MapCoordinator: MapViewModelDelegate {
    func dismissMapView(list: [String]) {
        delegate?.mapCoordinatorDidFinish(list: list)
    }
}
