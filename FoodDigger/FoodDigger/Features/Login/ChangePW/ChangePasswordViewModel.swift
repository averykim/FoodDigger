//
//  ProfileViewModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 5/7/26.
//
import Foundation

class ChangePasswordViewModel {

    //coordinate
    var closeChangePasswordView: (() -> Void)?

    //view
    var onOldPasswordError: ((Bool, String?) -> Void)?
    var onPasswordError: ((Bool, String?) -> Void)?
    var onPasswordMatchError: ((Bool, String?) -> Void)?
    var onSaveButonEnable: ((Bool) -> Void)?
    var onSaveFailure: ((String) -> Void)?

    private var oldPassword = ""
    private var newPassword = ""
    private var isOldPasswordValid = false
    private var isPasswordValid = false
    private var isConfirmValid = false

    func changePassword() {
        Task {
            do {
                let _ = try await AuthService().changePassword(oldPw: oldPassword, newPw: newPassword)
                await MainActor.run {
                    self.closeChangePasswordView?()
                }
            } catch let error as APIError {
                await MainActor.run {
                    self.onSaveFailure?(error.errorDescription ?? error.localizedDescription)
                }
            } catch {
                await MainActor.run {
                    onSaveFailure?("Network error")
                }
            }
        }
    }

    func ValidateOldPassword(_ pw: String) {
        if pw.isEmpty {
            isOldPasswordValid = false
            onOldPasswordError?(false, "Please enter old password.")
        } else {
            isOldPasswordValid = true
            oldPassword = pw
            onOldPasswordError?(true,"")
        }
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
        newPassword = confirmPw
        checkReadyToSave()
    }

    func checkReadyToSave() {
        let isReady = isOldPasswordValid && isPasswordValid && isConfirmValid
        onSaveButonEnable?(isReady)
    }

    func closeView() {
        closeChangePasswordView?()
    }
}
