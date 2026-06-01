//
//  GeneratorCoordinator.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/11/27.
//

import UIKit

class GeneratorCoordinator: Coordinator {

    let restaurants:[RestaurantUIModel]

    init(navigationController: UINavigationController, restaurants: [RestaurantUIModel]) {
        self.restaurants = restaurants
        super.init(navigationController: navigationController)
    }

    private var generatorViewModel: GeneratorViewModel?

    func start() {
        generatorViewModel = GeneratorViewModel(restaurants: restaurants)
        let generatorViewController = GeneratorViewController(viewModel: generatorViewModel ??
                                                              GeneratorViewModel(restaurants: restaurants))
        bind()
        navigationController.pushViewController(generatorViewController, animated: true)
    }

    func bind() {
        generatorViewModel?.navigateToHome = {[weak self] in
            self?.goToHome()
        }
    }

    private func goToHome() {
        childCoordinators[GeneratorCoordinator.self] = nil
        navigationController.popToRootViewController(animated: true)
    }

}
