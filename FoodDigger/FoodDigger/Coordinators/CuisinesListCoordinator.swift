//
//  CuisinesListCoordinator.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/16.
//

import Foundation

class CuisinesListCoordinator: Coordinator {

    func start() {
        let cuisinesViewModel = CuisinesListViewModel()
        let cuisinesViewController = CuisinesListViewController(viewModel: cuisinesViewModel)
        cuisinesViewModel.delegate = self
        navigationController.pushViewController(cuisinesViewController, animated: true)
    }
}

extension CuisinesListCoordinator: CuisinesListViewModelDelegate {
}
