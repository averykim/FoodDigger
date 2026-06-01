//
//  LoginCoordinator.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/23/26.
//

import UIKit

class AuthCoordinator: Coordinator {

    var loginDidFinish: (() -> Void)?

    func start() {
        let loginVM = LoginViewModel()
        let loginVC  = LoginViewController(viewModel: loginVM)

        loginVM.navigateToRegister = {[weak self] in self?.showRegister()}
        loginVM.navigateToFindView = {[weak self] in self?.showFindPassword()}
        loginVM.onLoginSuccess = {[weak self] in self?.finishAuth()}

        loginVM.closeLoginView = {[weak self] in self?.finishAuth()}

        navigationController.setViewControllers([loginVC], animated: false)
    }

    func showRegister() {
        let registerVM = RegisterViewModel()
        let registerVC = RegisterViewController(viewModel: registerVM)
        registerVM.navigateToLogin = {[weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        navigationController.pushViewController(registerVC, animated: true)
    }

    func showFindPassword() {
        let findPasswordVM = FindPasswordViewModel()
        let findPasswordVC = FindPasswordViewController(viewModel: findPasswordVM)
        findPasswordVM.navigateToLogin = {[weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        navigationController.pushViewController(findPasswordVC, animated: true)
    }

    func finishAuth() {
        loginDidFinish?()
    }
}
