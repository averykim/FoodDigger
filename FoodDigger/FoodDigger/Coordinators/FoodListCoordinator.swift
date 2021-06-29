//
//  FoodListCoordinator.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/29.
//

import UIKit

class FoodListCoordinator: Coordinator {

    func start() {
        let foodListViewModel = FoodListViewModel()
        foodListViewModel.delegate = self
        let foodListViewController = FoodListViewController(viewModel: foodListViewModel)
        navigationController.pushViewController(foodListViewController, animated: true)
    }
}

extension FoodListCoordinator: FoodListViewModelDelegate {
}
