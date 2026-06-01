//
//  changePasswordViewController.swift
//  FoodDigger
//
//  Created by JihyeKim on 5/7/26.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    let changePasswordView = ChangePasswordView()
    let viewModel: ChangePasswordViewModel


    init(viewModel: ChangePasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        bindViewModel()
        changePasswordView.oldPasswordInput.textField.delegate = self
        changePasswordView.newPaswwordInput.textField.delegate = self
        changePasswordView.newPasswordConfirmInput.textField.delegate = self
        setupRealTimeValidation()

    }

    override func loadView() {
        super.loadView()
        view = changePasswordView
    }

    private func bindView() {
        changePasswordView.onCloseTapped = {[weak self] in
            self?.viewModel.closeView()
        }
        changePasswordView.onSaveTapped = {[weak self] in
            self?.viewModel.changePassword()
        }
    }

    private func bindViewModel() {
        viewModel.onOldPasswordError = {[weak self] state, errorMsg in
            self?.changePasswordView.oldPasswordInput.showError(state, message: errorMsg)
        }
        viewModel.onPasswordError = {[weak self] state, errorMsg in
            self?.changePasswordView.newPaswwordInput.showError(state, message: errorMsg)
        }
        viewModel.onPasswordMatchError = {[weak self] state, errorMsg in
            self?.changePasswordView.newPasswordConfirmInput.showError(state, message: errorMsg)
        }
        viewModel.onSaveButonEnable = {[weak self] isReady in
            self?.changePasswordView.saveButton.isEnabled = isReady
            if isReady {
                self?.changePasswordView.saveButton.alpha = 1
            } else {
                self?.changePasswordView.saveButton.alpha = 0.5
            }
        }
        viewModel.onSaveFailure = {[weak self] msg in
            let alert = UIAlertController(title: "Notification", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            self?.present(alert, animated: true)
        }
    }

    private func setupRealTimeValidation() {
        changePasswordView.oldPasswordInput.textField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        changePasswordView.newPaswwordInput.textField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        changePasswordView.newPasswordConfirmInput.textField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
    }

    @objc
    private func passwordChanged(_ textField: UITextField) {
        let oldPw = changePasswordView.oldPasswordInput.text ?? ""
        let newPw = changePasswordView.newPaswwordInput.text ?? ""
        let confirmNewPw = changePasswordView.newPasswordConfirmInput.text ?? ""
        viewModel.ValidateOldPassword(oldPw)
        viewModel.validatePassword(newPw)
        if !confirmNewPw.isEmpty {
            viewModel.validatePasswordMatch(newPw, confirmPw: confirmNewPw)
        } else {
            changePasswordView.newPasswordConfirmInput.showError(true, message: nil)
        }
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == changePasswordView.oldPasswordInput.textField {
            changePasswordView.newPaswwordInput.textField.becomeFirstResponder()
        } else if textField == changePasswordView.newPaswwordInput.textField {
            changePasswordView.newPasswordConfirmInput.textField.becomeFirstResponder()
        } else {
            textField.endEditing(true)
        }
        return true
    }
}
