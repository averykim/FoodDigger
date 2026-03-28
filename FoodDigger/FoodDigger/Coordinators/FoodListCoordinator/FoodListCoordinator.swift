//
//  FoodListCoordinator.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/29.
//

import UIKit

protocol FoodListCoordinatorDelegate: AnyObject {
    func foodListCoordinatorDidFinish()
    func generateCoordinatorDidFinish()
}

class FoodListCoordinator: Coordinator {

    weak var delegate: FoodListCoordinatorDelegate?
    let cuisine: String

    init(navigationController: UINavigationController, cuisine: String) {
        self.cuisine = cuisine
        super.init(navigationController: navigationController)
    }

    private var foodListViewModel: FoodListViewModel?

    func start() {
        foodListViewModel = FoodListViewModel(cuisine: cuisine)
        foodListViewModel?.delegate = self
        let foodListViewController = FoodListViewController(viewModel: foodListViewModel ??
                                                            FoodListViewModel(cuisine: cuisine))
        navigationController.pushViewController(foodListViewController, animated: true)
    }
}

extension FoodListCoordinator: FoodListViewModelDelegate {
    func goToMapModal(info: [MapInfoModel]) {
        let coordinator = MapCoordinator(navigationController: navigationController)
        childCoordinators[MapCoordinator.self] = coordinator
        coordinator.delegate = self
        coordinator.start(info: info)
    }

    func goToCuisineListView() {
        navigationController.popToRootViewController(animated: true)
        delegate?.foodListCoordinatorDidFinish()
    }

    func goToGeneratorView(list: [String]) {
        let coordinator = GeneratorCoordinator(navigationController: navigationController,
                                                        cuisineList: list)
        childCoordinators[GeneratorCoordinator.self] = coordinator
        coordinator.delegate = self
        coordinator.start()
    }
}

extension FoodListCoordinator: MapCoordinatorDelegate {
    func mapCoordinatorDidFinish(list: [String]) {
        foodListViewModel?.addSelectedMarkerInfo(restaurantId: list)
        navigationController.dismiss(animated: true, completion: nil)
    }
}

extension FoodListCoordinator: GeneratorCoordinatorDelegate {
    func generatorCoordinatorDidFinish() {
        navigationController.popToRootViewController(animated: true)
        delegate?.generateCoordinatorDidFinish()
    }
}
