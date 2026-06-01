//
//  FindPWViewController.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/23/26.
//

import UIKit

class FindPasswordViewController: UIViewController {

    let findPasswordView = FindPasswordView()
    let viewModel: FindPasswordViewModel

    init(viewModel: FindPasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        findPasswordView.emailInput.textField.delegate = self
        bindView()
        bindViewModel()
    }

    override func loadView() {
        super.loadView()
        view = findPasswordView
    }

    private func  bindView() {
        findPasswordView.onSendTapped = {[weak self] in
            self?.viewModel.sendPassword(email: self?.findPasswordView.emailInput.text)
        }
        findPasswordView.emailInput.textField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)

        findPasswordView.onBackTapped = {[weak self] in
            self?.viewModel.backToLogin()
        }
    }

    private func bindViewModel() {
        viewModel.onFindSuccess = {[weak self] msg in
            let alert = UIAlertController(title: "Success", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default) {_ in
                self?.viewModel.backToLogin()
            })
            self?.present(alert, animated: true)
        }
        viewModel.onFindFailure = {[weak self] msg in
            let alert = UIAlertController(title: "Notification", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            self?.present(alert, animated: true)
        }
        viewModel.onEmailValidationFeedback = {[weak self] state, msg in
            self?.findPasswordView.emailInput.showError(state, message: msg)
        }
        viewModel.onSendButtonEnable = {[weak self] isReady in
            self?.findPasswordView.sendButton.isEnabled = true
        }
        viewModel.onLoadingStateChanged = {[weak self] isLoading in
            if isLoading {
                self?.findPasswordView.activityIndicator.startAnimating()
                self?.findPasswordView.sendButton.isEnabled = false
            } else {
                self?.findPasswordView.activityIndicator.stopAnimating()
                self?.findPasswordView.activityIndicator.hidesWhenStopped = true
                self?.findPasswordView.sendButton.isEnabled = true
            }
        }
    }

    @objc
    private func emailChanged(_ textField: UITextField) {
        viewModel.validateEmail(textField.text ?? "")
    }
}
extension FindPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
