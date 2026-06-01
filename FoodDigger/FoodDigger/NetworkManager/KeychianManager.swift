//
//  KeychianManageer.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/10/26.
//

import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()
    private init() {}

    func save(token: String, account: String) -> Bool {
        guard let data = token.data(using: .utf8) else {return false}

        // Setting a query for accessing keychain. account = 'accessToken' or 'refreshToken'
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]

        //Delete first
        SecItemDelete(query as CFDictionary)

        // Add new token data
        var queryToSave = query
        queryToSave[kSecValueData as String] = data

        let status = SecItemAdd(queryToSave as CFDictionary, nil)
        return status == errSecSuccess
    }

    func read(account:String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne //find only one data
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    func delete(account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary)
    }
}
