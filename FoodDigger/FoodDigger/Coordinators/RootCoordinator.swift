//
//  RootCoordinator.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/16.
//

import Foundation

class RootCoordinator: Coordinator {

    func start() {
        let coordinator = CuisinesListCoordinator(navigationController: navigationController)
        childCoordinators[CuisinesListCoordinator.self] = coordinator
        coordinator.start()
    }
}
