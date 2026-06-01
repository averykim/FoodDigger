//
//  MapCoordinator.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/11/10.
//

import UIKit

class MapCoordinator: Coordinator {

    var mapModalDidFinish: (([RestaurantModel]) -> Void)?

    let cuisine: String
    init(navigationController: UINavigationController, cuisine: String) {
        self.cuisine = cuisine
        super.init(navigationController: navigationController)
    }
    func start() {
        let mapViewModel = MapViewModel(cuisine)
        let mapViewController  = MapViewController(viewModel: mapViewModel)
        mapViewController.modalPresentationStyle = .fullScreen
        mapViewController.modalTransitionStyle = .crossDissolve

        mapViewModel.dismissMapView = {[weak self]  restaurants in
            self?.mapModalDidFinish?(restaurants)
            self?.navigationController.dismiss(animated: true, completion: nil)
        }
        navigationController.present(mapViewController, animated: false, completion: nil)
    }
}
