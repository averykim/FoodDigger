//
//  Services.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/10/26.
//

import Foundation

class AuthService {
    private let network = APIClient.shared

    func register(data: UserModel) async throws -> Bool {
        do {
            let encodeData = try JSONEncoder().encode(data)

            let result: DefaultResponse = try await network.request(endpoint: .register, body: encodeData)

            if let errorMsg = result.error, !errorMsg.isEmpty {
                return false
            }
            return true

        } catch {
            throw error
        }
    }

    func login(id: String, pw: String) async throws -> Bool {
        do {
            let params = ["email": id, "password": pw]
            let bodyData = try? JSONSerialization.data(withJSONObject: params)

            let result: AuthResponse = try await network.request(endpoint: .login, body: bodyData)

            let isAccessSaved = KeychainManager.shared.save(token: result.access, account: "accessToken")
            let isRefreshSaved = KeychainManager.shared.save(token: result.refresh, account: "refreshToken")
            if isAccessSaved && isRefreshSaved {
                UserDefaults.standard.set(result.username, forKey: "username")
                UserDefaults.standard.set(result.email, forKey: "email")
            } else {
                return false
            }

            return true

        } catch {
            print("error: \(error)")
            throw error
        }
    }

    func logout() async throws -> DefaultResponse {
        guard let refreshToken = KeychainManager.shared.read(account: "refreshToken") else {
            throw APIError.unknown
        }

        do {
            let requestDict = ["refresh": refreshToken]
            guard let bodyData = try? JSONSerialization.data(withJSONObject: requestDict) else {throw APIError.decodingFailed}
            let result: DefaultResponse = try await network.request(endpoint: .logout, body: bodyData)

            KeychainManager.shared.delete(account: "accessToken")
            KeychainManager.shared.delete(account: "refreshToken")

            if let errorMsg = result.error, !errorMsg.isEmpty {
                throw APIError.serverError(errorMsg)
            }

            return result
        } catch {
            throw error
        }

    }

    func getProfile() async throws -> [String:String]{
        do {
            let result: [String:String] = try await network.request(endpoint: .fetchProfile)
            return result
        } catch {
            throw error
        }
    }

    func findPassword(email: String) async throws -> DefaultResponse {
        do {
            let requestDict = ["email": email]
            guard let bodyData = try? JSONSerialization.data(withJSONObject: requestDict) else { throw APIError.decodingFailed }
            let result: DefaultResponse = try await network.request(endpoint: .findPassword, body: bodyData)

            return result

        } catch let error as APIError {
            throw APIError.serverError(error.errorDescription ?? "\(error.localizedDescription)")
        } catch {
            throw error
        }

    }

    func changePassword(oldPw: String, newPw: String) async throws -> DefaultResponse {
        do {
            let requestDict = ["old_password": oldPw, "new_password": newPw]
            guard let bodyData = try? JSONSerialization.data(withJSONObject: requestDict) else { throw APIError.decodingFailed}
            let result: DefaultResponse = try await network.request(endpoint: .changePassword, body: bodyData)

            return result

        } catch let error as APIError {
            throw APIError.serverError(error.errorDescription ?? "\(error.localizedDescription)")
        } catch {
            throw error
        }
    }
}

class RestaurantService {
    struct YelpResponse: Decodable {
        let results: [RestaurantModel]
    }
    let network = APIClient.shared

    func getRestaurants(lat: Double, lon: Double, category: String) async throws -> [RestaurantModel]  {
        do {
            let response: YelpResponse = try await network.request(
                endpoint: .fetchRestaurants(lat: lat, lon: lon, category: category)
            )
            return response.results
        } catch {
            throw error
        }
    }
}

class HistoryService {
    let network = APIClient.shared

    func saveToHistory(item: RestaurantUIModel) async throws -> HistoryModel {
        do {
            let params: [String: Any] = [
                "yelp_id": item.yelpId ?? NSNull(),
                "is_custom": item.isCustom,
                "restaurant_name": item.name,
                "address": item.address,
                "image_url": item.imageUrl ?? NSNull(),
                "rating": item.rating ?? 0.0
            ]

            let encodeData = try JSONSerialization.data(withJSONObject: params, options: [])
            let result: HistoryModel = try await network.request(endpoint: .saveRestaurants, body: encodeData)

            return result
        } catch {
            throw error
        }
    }

    func getHisory() async throws -> [HistoryModel] {
        do {
            let response: [HistoryModel] = try await network.request(endpoint: .fetchHistory)
            return response
        } catch {
            throw  error
        }
    }

    func deleteHistory(yelpId: String?, historyId: Int?) async throws -> Bool {
        do {
            let result: DefaultResponse = try await network.request(endpoint: .deleteHistory(yelpId: yelpId, historyId: historyId))

            if let errorMsg = result.error, !errorMsg.isEmpty {
                throw APIError.serverError(errorMsg)
            }

            return true
        } catch DecodingError.dataCorrupted(_) {
            //Success to delete,No Content
            return true
        } catch {
            throw error
        }
    }
}
