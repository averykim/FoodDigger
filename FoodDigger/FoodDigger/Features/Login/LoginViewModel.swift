//
//  LoginViewModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/23/26.
//

import Foundation

class LoginViewModel {

    //Navigation Clousres
    var navigateToRegister: (() -> Void)?
    var navigateToFindView: (() -> Void)?
    var closeLoginView: (()->Void)?
    var onLoginSuccess: (() -> Void)?

    //View Closures
    var onErrorMessage: ((String) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?

    init() {

    }

    func loginUser(email: String?, password: String?) {
        guard let email = email, !email.isEmpty else {
            onErrorMessage?("Please enter your email address.")
            return
        }

        guard let password = password, !password.isEmpty else {
            onErrorMessage?("Please enter your password.")
            return
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if !emailTest.evaluate(with: email) {
            onErrorMessage?("Please enter a validate email address.")
            return
        }

        let pwRegEx = "^[a-zA-Z0-9]{8,}$"
        let pwTest = NSPredicate(format: "SELF MATCHES %@", pwRegEx)
        if !pwTest.evaluate(with: password) {
            onErrorMessage?("Password must be at least 8 alphanumeric characters.")
            return
        }

        onLoadingStateChanged?(true)

        Task {
            do {
                let success = try await AuthService().login(id: email, pw: password)

                await MainActor.run {
                    if success {
                        onLoadingStateChanged?(false)
                        NotificationCenter.default.post(name: NSNotification.Name("LoginSuccess"), object: nil)
                        onLoginSuccess?()
                    } else {
                        self.onErrorMessage?("Fail to login (Token save error)")
                        onLoadingStateChanged?(false)
                    }
                }
            } catch {
                await MainActor.run {
                    onLoadingStateChanged?(false)
                    onErrorMessage?("Invalid email or password")
                }
                print(error.localizedDescription)
            }
        }
    }

    func moveToReigsterView() {
        navigateToRegister?()
    }

    func moveToFindView() {
        navigateToFindView?()
    }

    func closeView() {
        closeLoginView?()
    }
}
