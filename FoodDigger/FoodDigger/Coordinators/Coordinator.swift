//
//  Coordinator.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/15.
//

import UIKit

class Coordinator {

    let navigationController: UINavigationController
    var childCoordinators = CoordinatorDictionary<Coordinator>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
