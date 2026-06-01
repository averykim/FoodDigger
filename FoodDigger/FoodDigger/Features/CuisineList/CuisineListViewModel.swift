//
//  CuisineViewModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/16.
//

import Foundation

class CuisineListViewModel {

    //coordinate
    var navigateToNext: ((String) -> Void)?
    var onAuthButtonTapped: (() -> Void)?
    var navigateToHistoryModal: (() -> Void)?
    var navigateToChangePasswordModal: (() -> Void)?

    //View
    var onAuthStateChanged: ((Bool) -> Void)?
    var showProfileMenu: ((String) -> Void)?

    var cuisines = [CuisineType: String]()
    subscript(type: CuisineType) -> String? {
        get {
            return cuisines[type]
        }
        set(newType) {
            return cuisines[type] = newType
        }
    }

    init() {
        initializeDict()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkLoginStatus),
                                               name: NSNotification.Name("LoginSuccess"),
                                               object: nil)
    }

    func initializeDict() {
        for type in CuisineType.cases {
            cuisines[type] = NSLocalizedString(type.rawValue, comment: "")
        }
    }

    @objc
    func checkLoginStatus() {
        let isLoggedIn = KeychainManager.shared.read(account: "accessToken") != nil
        if isLoggedIn {
            fetchUserName(completion: { [weak self] info in
                self?.showProfileMenu?(info["username"] ?? "")
            })
        }

        onAuthStateChanged?(isLoggedIn)
    }

    func fetchUserName(completion: @escaping ([String: String]) -> Void) {
        if let name = UserDefaults.standard.string(forKey: "username"),
           let email = UserDefaults.standard.string(forKey: "email") {
            completion(["username": name, "email": email])
            return
        }

        Task {
            do {
                let fetchedData = try await AuthService().getProfile()
                if let newName = fetchedData["username"], let newEmail  = fetchedData["email"] {
                    UserDefaults.standard.set(newName, forKey: "username")
                    UserDefaults.standard.set(newEmail, forKey: "email")
                }
                DispatchQueue.main.async {
                    completion(fetchedData)
                }
            } catch {
                print("Fail to get profile: \(error)")
                DispatchQueue.main.async {
                    completion([:])
                }
            }
        }
    }


    func changeCuisinesState(type: CuisineType) {
        if cuisines[type] != nil && cuisines.count != 1 {
            cuisines.removeValue(forKey: type)
        } else {
            cuisines[type] = NSLocalizedString(type.rawValue, comment: "")
        }
    }

    func moveToFoodListView() {
        if let randomValue = cuisines.randomElement()?.value {
            navigateToNext?(randomValue)
        }
    }

    func moveToAuthView() {
        onAuthButtonTapped?()
    }

    func moveToHistoryModal() {
        navigateToHistoryModal?()
    }

    func moveToPasswordView() {
        navigateToChangePasswordModal?()
    }

    func logout() {
        Task {
            do {
                let _ =  try await AuthService().logout()
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.removeObject(forKey: "email")
                checkLoginStatus()
            } catch {
                print("error: \(error)")
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
