//
//  LoginViewController.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/23/26.
//

import UIKit

class LoginViewController: UIViewController {

    let loginView = LoginView()
    let viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.emailInput.textField.delegate = self
        loginView.passwordInput.textField.delegate = self
        bindViewModel()
        bindView()
    }

    override func loadView() {
        super.loadView()
        view = loginView
    }

    private func bindViewModel() {
        viewModel.onErrorMessage = {[weak self] message in self?.showAlert(message: message)}
        viewModel.onLoadingStateChanged = {[weak self] isLoading in
            if isLoading {
                self?.loginView.activityIndicator.startAnimating()
                self?.loginView.loginButton.isEnabled = false
            } else {
                self?.loginView.activityIndicator.stopAnimating()
                self?.loginView.activityIndicator.hidesWhenStopped = true
                self?.loginView.loginButton.isEnabled = true
            }
        }
    }

    private func bindView() {
        loginView.onCloseTapped = {[weak self] in self?.viewModel.closeView()}
        loginView.onLoginTapped = {[weak self] in
            self?.viewModel.loginUser(email: self?.loginView.emailInput.textField.text,
                                      password: self?.loginView.passwordInput.textField.text)
        }
        loginView.onRegisterTapped = {[weak self] in self?.viewModel.moveToReigsterView()}
        loginView.onFindTapped = {[weak self] in self?.viewModel.moveToFindView()}
    }
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Notification", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alert, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginView.emailInput.textField {
            loginView.passwordInput.textField.becomeFirstResponder()
        } else if textField == loginView.passwordInput.textField {
            textField.resignFirstResponder()
            loginView.loginButton.sendActions(for: .touchUpInside)

        }
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
