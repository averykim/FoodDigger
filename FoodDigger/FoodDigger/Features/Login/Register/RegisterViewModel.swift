//
//  RegisterViewModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/23/26.
//

import Foundation

class RegisterViewModel {

    // Coordinator closures
    var navigateToLogin: (()->Void)?

    // View closures
    var onRegisterSuccess: (() -> Void)?
    var onRegisterFailure: ((String) -> Void)?
    var onEmailError: ((Bool, String?) -> Void)?
    var onUsernameError: ((Bool, String?) -> Void)?
    var onPasswordError: ((Bool, String?) -> Void)?
    var onPasswordMatchError: ((Bool, String?) -> Void)?
    var onRegisterButonEnable: ((Bool) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?

    //Current state variables
    private var currentPassword = ""
    private var currentEmail = ""
    private var currentName = ""
    private var isEmailValid = false
    private var isUsernameValid = false
    private var isPasswordValid = false
    private var isConfirmValid = false


    func registerUser() {
        let isReady = isEmailValid && isUsernameValid && isPasswordValid && isConfirmValid
        let requestData = UserModel(username: currentName, email: currentEmail, password: currentPassword)

        onLoadingStateChanged?(isReady)

        Task {
            do {
                let success = try await AuthService().register(data: requestData)
                await MainActor.run {
                    onLoadingStateChanged?(false)
                    if success {
                        self.onRegisterSuccess?()
                    } else {
                        self.onRegisterFailure?("Fail to register, please try again.")
                    }
                }
            } catch {
                await MainActor.run {
                    self.onLoadingStateChanged?(false)
                    onRegisterFailure?("Network error: \(error.localizedDescription)")
                }
            }
        }
    }

    func validateEmail(_ email: String) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

        if email.isEmpty {
            isEmailValid = false
            onEmailError?(false, "")
        } else if emailTest.evaluate(with: email) {
            isEmailValid = true
            onEmailError?(true, "")
        } else {
            isEmailValid = false
            onEmailError?(false, "Please enter a validate email address.")
        }

        currentEmail =  email
        checkReadyToRegister()
    }

    func validatePassword(_ pw: String) {
        let pwRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let pwTest = NSPredicate(format: "SELF MATCHES %@", pwRegEx)
        if pw.isEmpty {
            isPasswordValid = false
            onPasswordError?(false, "")
        } else if pwTest.evaluate(with: pw) {
            isPasswordValid = true
            onPasswordError?(true, "")
        } else {
            isPasswordValid = false
            onPasswordError?(false, "Password must be at least 8 characters with letters and numbers.")
        }

        checkReadyToRegister()
    }

    func validatePasswordMatch(_ pw: String, confirmPw: String) {
        if pw.isEmpty {
            isConfirmValid = false
            onPasswordMatchError?(false, "")
        } else if pw == confirmPw {
            isConfirmValid = true
            onPasswordMatchError?(true, "")
        } else {
            isConfirmValid = false
            onPasswordMatchError?(false, "Confirm password is not matched.")
        }
        currentPassword = confirmPw
        checkReadyToRegister()
    }

    func validateUsername(_ name: String)  {
        if name.isEmpty {
            isUsernameValid = false
            onUsernameError?(false, "User name must be between 2 and 9 characters.")
        } else if name.count >= 2 || name.count < 10 {
            isUsernameValid = true
            onUsernameError?(true, "")
        } else {
            isUsernameValid = false
            onUsernameError?(false, "User name must be between 2 and 9 characters.")
        }
        currentName = name
        checkReadyToRegister()
    }

    func checkReadyToRegister() {
        let isReady = isEmailValid && isUsernameValid && isPasswordValid && isConfirmValid
        onRegisterButonEnable?(isReady)
    }

    func backToLogin() {
        navigateToLogin?()
    }
}
