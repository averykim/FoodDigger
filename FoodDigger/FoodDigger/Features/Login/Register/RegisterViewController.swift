//
//  RegisterViewController.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/23/26.
//

import UIKit

class RegisterViewController: UIViewController {

    let registerView = RegisterView()
    let viewModel: RegisterViewModel

    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerView.emailInput.textField.delegate = self
        registerView.usernameInput.textField.delegate = self
        registerView.pwInput.textField.delegate = self
        registerView.pwConfirmInput.textField.delegate = self
        bindView()
        bindViewModel()
        setupRealTimeValidation()
    }

    override func loadView() {
        super.loadView()
        view = registerView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func bindView() {
        registerView.onRegisterTapped = {[weak self] in
            self?.viewModel.registerUser()
        }
        registerView.onBackTapped = {[weak self] in
            self?.viewModel.backToLogin()
        }
    }

    func bindViewModel() {

        viewModel.onRegisterSuccess = {[weak self] in
            let alert = UIAlertController(title: "Success", message: "You have successfully signed up.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default) {_ in 
                self?.viewModel.backToLogin()
            })
            self?.present(alert, animated: true)
        }
        viewModel.onRegisterFailure = {[weak self] msg in
            let alert = UIAlertController(title: "Notification", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            self?.present(alert, animated: true)
        }
        viewModel.onEmailError = {[weak self] state, errorMsg in
            self?.registerView.emailInput.showError(state, message: errorMsg)
        }
        viewModel.onUsernameError = {[weak self] state, errorMsg in
            self?.registerView.usernameInput.showError(state, message: errorMsg)
        }
        viewModel.onPasswordError = {[weak self] state, errorMsg in
            self?.registerView.pwInput.showError(state, message: errorMsg)
        }
        viewModel.onPasswordMatchError = {[weak self] state, errorMsg in
            self?.registerView.pwConfirmInput.showError(state, message: errorMsg)
        }
        viewModel.onRegisterButonEnable = {[weak self] isReady in
            self?.registerView.registerButton.isEnabled = isReady
        }
        viewModel.onLoadingStateChanged = {[weak self] isLoading in
            if isLoading {
                self?.registerView.activityIndicator.startAnimating()
                self?.registerView.registerButton.isEnabled = false
            } else {
                self?.registerView.activityIndicator.stopAnimating()
                self?.registerView.activityIndicator.hidesWhenStopped = true
                self?.registerView.registerButton.isEnabled = true
            }
        }
    }

    private func setupRealTimeValidation() {
        registerView.emailInput.textField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        registerView.usernameInput.textField.addTarget(self, action: #selector(usernameChanged), for: .editingChanged)
        registerView.pwInput.textField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        registerView.pwConfirmInput.textField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
    }

    @objc
    private func emailChanged(_ textField: UITextField) {
        viewModel.validateEmail(textField.text ?? "")
    }

    @objc
    private func usernameChanged(_ textField: UITextField) {
        viewModel.validateUsername(textField.text ?? "")
    }

    @objc
    private func passwordChanged(_ textField: UITextField) {
        let pw = registerView.pwInput.text ?? ""
        let confirmPw = registerView.pwConfirmInput.text ?? ""

        viewModel.validatePassword(pw)
        if !confirmPw.isEmpty {
            viewModel.validatePasswordMatch(pw, confirmPw: confirmPw)
        } else {
            registerView.pwConfirmInput.showError(true, message: nil)
        }
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if self.view.transform.ty == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: -100)
            })
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        if self.view.transform.ty != 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.transform = .identity
            })
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == registerView.emailInput.textField {
            registerView.usernameInput.textField.becomeFirstResponder()
        } else if textField == registerView.usernameInput.textField {
            registerView.pwInput.textField.becomeFirstResponder()
        } else if textField == registerView.pwInput.textField {
            registerView.pwConfirmInput.textField.becomeFirstResponder()
        } else if textField == registerView.pwConfirmInput.textField {
            textField.resignFirstResponder()
        } else {
            textField.endEditing(true)
        }
        return true
    }
}
