//
//  FoodListCoordinator.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/29.
//

import UIKit

class FoodListCoordinator: Coordinator {

    let cuisine: String

    init(navigationController: UINavigationController, cuisine: String) {
        self.cuisine = cuisine
        super.init(navigationController: navigationController)
    }

    func start() {
        let foodListViewModel = FoodListViewModel(cuisine: cuisine)
        foodListViewModel.delegate = self
        let foodListViewController = FoodListViewController(viewModel: foodListViewModel)
        navigationController.pushViewController(foodListViewController, animated: true)
    }
}

extension FoodListCoordinator: FoodListViewModelDelegate {
}
