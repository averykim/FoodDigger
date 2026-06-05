//
//  Untitled.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/10/26.
//

import Foundation

enum FoodDiggerAPI {
    case login
    case register
    case saveRestaurants
    case fetchRestaurants(lat: Double, lon: Double, category: String)
    case fetchHistory
    case findPassword
    case changePassword
    case fetchProfile
    case logout

    //DELETE
    case deleteHistory(yelpId: String?, historyId: Int?)

    var baseURL: String {
        return "http://127.0.0.1:8000"
    }

    var requiresAuth: Bool {
        switch self {
        case .login, .register, .findPassword:
            return false
        case .fetchRestaurants, .fetchHistory, .deleteHistory,
                .saveRestaurants, .fetchProfile, .changePassword,
                .logout:
            return true
        }
    }

    var path: String {
        switch self {
        case .login:
            return "/auth/login/"
        case .register:
            return "/auth/register/"
        case .findPassword:
            return "/auth/reset-password/"
        case .changePassword:
            return "/auth/change-password/"
        case .saveRestaurants, .fetchHistory:
            return "/restaurants/history/"
        case .fetchRestaurants:
            return "/restaurants/search-yelp/"
        case .deleteHistory:
            return "/restaurants/history/"
        case .fetchProfile:
            return "/auth/profile/"
        case .logout:
            return "/auth/logout/"
        }
    }

    var method:String {
        switch self {
        case .login, .register, .saveRestaurants,
                .findPassword, .changePassword, .logout:
            return "POST"
        case .fetchRestaurants, .fetchHistory, .fetchProfile:
            return "GET"
        case .deleteHistory:
            return "DELETE"
        }
    }

    var url: URL? {
        var components = URLComponents(string: baseURL + path)

        switch self {
        case.fetchRestaurants(let lat, let lon, let category):
            components?.queryItems = [
                URLQueryItem(name: "latitude", value: String(lat)),
                URLQueryItem(name: "longitude", value: String(lon)),
                URLQueryItem(name: "category", value: category)
            ]
        case .deleteHistory(let yelpId, let historyId):
            var queryItems = [URLQueryItem]()
            if let yelpId = yelpId {
                queryItems.append(URLQueryItem(name: "yelp_id", value: yelpId))
            } else if let historyId = historyId {
                queryItems.append(URLQueryItem(name: "id", value: String(historyId)))
            }
            components?.queryItems = queryItems
        default: break
        }
        return components?.url
    }
}

enum APIError: LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingFailed
    case unknown

    case invalidRequest
    case serverError(String)

    var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "The URL provided was invalid."
            case .requestFailed(let statusCode):
                return "The request failed with status code: \(statusCode)."
            case .decodingFailed:
                return "Failed to decode the data from the server."
            case .unknown:
                return "An unknown error occurred. Please try again later."
            case .invalidRequest:
                return "The request data was invalid."
            case .serverError(let message):
                return message
            }
        }
}
