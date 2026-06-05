//
//  FoodListCoordinator.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/29.
//

import UIKit

class FoodListCoordinator: Coordinator {

    let cuisine: String
//    var backToRootView: (() -> Void)?

    init(navigationController: UINavigationController, cuisine: String) {
        self.cuisine = cuisine
        super.init(navigationController: navigationController)
    }

    private var foodListViewModel: FoodListViewModel?

    func start() {
        foodListViewModel = FoodListViewModel(cuisine: cuisine)
        let foodListViewController = FoodListViewController(viewModel: foodListViewModel ??
                                                            FoodListViewModel(cuisine: cuisine))

        bind()
        navigationController.pushViewController(foodListViewController, animated: true)
    }

    private func bind() {
        foodListViewModel?.navigateToHome = {[weak self] in
            self?.goToHomeView()
        }

        foodListViewModel?.navigateToRandomView = {[weak self] restaurants in
            self?.goToGeneratorView(list: restaurants)
        }

        foodListViewModel?.navigateToMapModal = {[weak self] cuisine in
            self?.goToMapModal(cuisine: cuisine)
        }
    }

    private func goToHomeView() {
        childCoordinators[FoodListCoordinator.self] = nil
        navigationController.popToRootViewController(animated: true)
    }

    private func goToGeneratorView(list: [RestaurantUIModel]) {
        let coordinator = GeneratorCoordinator(navigationController: navigationController,
                                                        restaurants: list)
        childCoordinators[GeneratorCoordinator.self] = coordinator
        coordinator.start()
    }

    private func goToMapModal(cuisine: String) {
        let coordinator = MapCoordinator(navigationController: navigationController, cuisine: cuisine)
        childCoordinators[MapCoordinator.self] = coordinator
        coordinator.start()

        coordinator.mapModalDidFinish = {[weak self] restaurants in
            self?.foodListViewModel?.addSelectedMarkerInfo(markers: restaurants)
        }
    }
}
