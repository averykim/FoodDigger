//
//  CuisinesListCoordinator.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/16.
//

import Foundation
import UIKit

class CuisinesListCoordinator: Coordinator {

    func start() {
        let cuisinesViewModel = CuisineListViewModel()
        let cuisinesViewController = CuisineListViewController(viewModel: cuisinesViewModel)

        if UserDefaults.standard.bool(forKey: "isLogout") {
            showLoginView()
            UserDefaults.standard.removeObject(forKey: "isLogout")
        }

        cuisinesViewModel.navigateToNext = { [weak self] category in
            self?.navigateToFoodListView(category: category)
        }

        cuisinesViewModel.onAuthButtonTapped = {[weak self] in
            self?.showLoginView()
        }
        cuisinesViewModel.navigateToChangePasswordModal = {[weak self] in
            self?.showChangePasswordView()
        }

        cuisinesViewModel.navigateToHistoryModal = {[weak self] in
            self?.showHistoryView()
        }

        navigationController.pushViewController(cuisinesViewController, animated: true)
    }

    private func navigateToFoodListView(category: String) {
        let coordinator = FoodListCoordinator(navigationController: navigationController, cuisine: category)
        childCoordinators[FoodListCoordinator.self] = coordinator
        coordinator.start()
    }

    private func showLoginView() {
        let authNavController = UINavigationController()
        let coordinator = AuthCoordinator(navigationController: authNavController)
        childCoordinators[AuthCoordinator.self] = coordinator
        coordinator.loginDidFinish = {[weak self] in
            self?.childCoordinators[AuthCoordinator.self] = nil
            authNavController.dismiss(animated: true)
        }
        coordinator.start()
        self.navigationController.present(authNavController, animated: true)
    }

    private func showChangePasswordView() {
        let changePasswordVM = ChangePasswordViewModel()
        let changePasswordVC = ChangePasswordViewController(viewModel: changePasswordVM)
        changePasswordVC.modalPresentationStyle = .overCurrentContext
        changePasswordVC.modalTransitionStyle = .crossDissolve
        changePasswordVM.closeChangePasswordView = {[weak self] in
            self?.navigationController.dismiss(animated: true)
        }
        self.navigationController.present(changePasswordVC, animated: true)
    }

    private func showHistoryView() {
        let coordinator = HistoryCoordinator(navigationController: navigationController)
        childCoordinators[HistoryCoordinator.self] = coordinator
        coordinator.historyModalDidFinish = {[weak self] in
            self?.childCoordinators[HistoryCoordinator.self] = nil
        }
        coordinator.start()
    }
}
