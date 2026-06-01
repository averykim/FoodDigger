//
//  Network.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/07/20.
//

import Foundation

class APIClient {
    static let shared = APIClient()
    let session: URLSession = URLSession(configuration: .default)

    func request<T:Decodable>(endpoint: FoodDiggerAPI, body: Data? = nil) async throws -> T {
        guard let url = endpoint.url else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method

        print("🚀 [요청 확인]: \(endpoint.method) \(url.absoluteString)")

        if endpoint.requiresAuth {
            if let token = KeychainManager.shared.read(account: "accessToken"){
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        // Success response
        if (200...299).contains(httpResponse.statusCode) {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        }

        // Error 401
        if httpResponse.statusCode == 401 {
            print("Access Token is expired")

            if let newAccessToken = try await refreshToken(endpoint.baseURL) {
                print("Success to get refresh Token")

                request.setValue("Bearer \(newAccessToken)", forHTTPHeaderField: "Authorization")
                let (retryData, retryResponse) = try await URLSession.shared.data(for: request)

                guard let retryHttpResponse = retryResponse as? HTTPURLResponse,
                        (200...299).contains(retryHttpResponse.statusCode) else {
                    throw URLError(.userAuthenticationRequired)
                }
                return try JSONDecoder().decode(T.self, from: retryData)
            } else {
                print("Refresh Token is also expired or invalid")
                NotificationCenter.default.post(name: NSNotification.Name("ForceLogout"), object: nil)
                throw APIError.requestFailed(statusCode: httpResponse.statusCode)
            }
        }
        //other error (404, 500)
        var errorMessage = "Unknown error"
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String:Any] {
            if let msg = json["error"] as? String {
                errorMessage = msg
            }
        }

        throw APIError.serverError(errorMessage)
    }

    private func refreshToken(_ baseUrl: String) async throws -> String? {
        guard let refreshToken  = KeychainManager.shared.read(account: "refreshToken") else {
            return nil
        }

        guard let url = URL(string: baseUrl + "/auth/token/refresh/") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["refresh": refreshToken]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let newAccessToken = json["access"] as? String {
                let isSaved = KeychainManager.shared.save(token: newAccessToken, account: "accessToken")
                return isSaved ? newAccessToken :  nil
            }
        }

        return nil
    }

    func send<T: CommonModel>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            var result: Result<T, Error>
            guard let httpResponse = response as? HTTPURLResponse else { return }
            //check error
            if let error = error, (400...500).contains(httpResponse.statusCode){
                result = .failure(error)
                completion(result)
            }

            if let data = data, (200...299).contains(httpResponse.statusCode) {
                do {
                    let decoder = JSONDecoder()
                    result = .success(try decoder.decode(T.self, from: data))
                } catch {
                    result = .failure(error)
                }
                completion(result)
            }
        }
        task.resume()
    }
}
