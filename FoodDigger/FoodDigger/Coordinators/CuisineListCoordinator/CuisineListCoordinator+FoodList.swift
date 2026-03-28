//
//  CuisineListCoordinator+FoodList.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/07/01.
//

import UIKit

extension CuisinesListCoordinator: FoodListCoordinatorDelegate {
    func generateCoordinatorDidFinish() {
        childCoordinators[GeneratorCoordinator.self] = nil
    }
    
    func foodListCoordinatorDidFinish() {
        childCoordinators[FoodListCoordinator.self] = nil
    }
}
