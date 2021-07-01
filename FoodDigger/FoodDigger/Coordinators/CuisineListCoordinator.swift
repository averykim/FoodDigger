//
//  CuisinesListCoordinator.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/16.
//

import Foundation

class CuisinesListCoordinator: Coordinator {

    func start() {
        let cuisinesViewModel = CuisineListViewModel()
        let cuisinesViewController = CuisineListViewController(viewModel: cuisinesViewModel)
        cuisinesViewModel.delegate = self
        navigationController.pushViewController(cuisinesViewController, animated: true)
    }
}

extension CuisinesListCoordinator: CuisineListViewModelDelegate {
    func goToHelpView() {
        // Add help page coordinator
        print("Add help page")
    }
    
    func goToFoodListView(cuisine: String) {
        let foodListCoordinator = FoodListCoordinator(navigationController: navigationController,
                                                      cuisine: cuisine)
        childCoordinators[FoodListCoordinator] = foodListCoordinator
        foodListCoordinator.start()
    }
}
