//
//  RootCoordinator.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/16.
//

import Foundation
import UIKit

class RootCoordinator: Coordinator {

    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleForceLogout),
                                               name: NSNotification.Name("ForceLogout"),
                                               object: nil)
    }

    func start() {
        let coordinator = CuisinesListCoordinator(navigationController: navigationController)
        childCoordinators[CuisinesListCoordinator.self] = coordinator
        coordinator.start()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc
    func handleForceLogout() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            print("force logout")

            KeychainManager.shared.delete(account: "accessToken")
            KeychainManager.shared.delete(account: "refreshToken")

            self.childCoordinators =  CoordinatorDictionary<Coordinator>()
            UserDefaults.standard.set(true, forKey: "isLogout")

            self.navigationController.dismiss(animated: false) {
                let alert = UIAlertController(title: "Expired", message: "Please login again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.start()
                })
                alert.addAction(okAction)

                self.navigationController.present(alert, animated: true)
            }
        }
    }
}
