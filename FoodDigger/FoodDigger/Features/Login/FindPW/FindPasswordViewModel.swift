//
//  FindPWViewModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/23/26.
//

import Foundation

class FindPasswordViewModel {

    // coordinator closure
    var navigateToLogin: (()->Void)?

    // view closures
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onFindSuccess: ((String) -> Void)?
    var onFindFailure: ((String) -> Void)?
    var onEmailValidationFeedback: ((Bool, String) -> Void)?
    var onSendButtonEnable: ((Bool) -> Void)?

    private var isEmailValid = false

    func sendPassword(email: String?) {
        guard let email = email, isEmailValid else {return}

        onLoadingStateChanged?(true)

        Task {
            do{
                let response = try await AuthService().findPassword(email: email)
                await MainActor.run {
                    self.onLoadingStateChanged?(false)
                    self.onFindSuccess?(response.message ?? "A password reset link has been sent your email.")
                }
            } catch let error as APIError {
                await MainActor.run {
                    self.onLoadingStateChanged?(false)
                    self.onFindFailure?(error.errorDescription ?? "Unregistered email or server error.")
                }
            } catch {
                await MainActor.run {
                    self.onLoadingStateChanged?(false)
                    self.onFindFailure?("Network error: \(error.localizedDescription)")
                }
            }
        }
    }

    func validateEmail(_ email: String) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

        if email.isEmpty {
            isEmailValid = false
            onEmailValidationFeedback?(false, "")
        } else if emailTest.evaluate(with: email) {
            isEmailValid = true
            onEmailValidationFeedback?(true, "")
        } else {
            isEmailValid = false
            onEmailValidationFeedback?(false, "Please enter a validate email address.")
        }
        onSendButtonEnable?(isEmailValid)
    }

    func backToLogin() {
        navigateToLogin?()
    }
}
