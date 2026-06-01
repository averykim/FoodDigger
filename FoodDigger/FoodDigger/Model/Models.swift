//
//  HistoryModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 4/13/26.
//


import Foundation

struct DefaultResponse: Codable {
    let message: String?
    let error: String?
}

struct AuthResponse: Codable {
    let access: String
    let refresh: String
    let username: String
    let email: String
}

struct UserModel: Codable {
    let username: String
    let email: String
    let password: String
}

struct RestaurantModel:Codable, Identifiable {
    let id: String
    let name: String
    let imageUrl: String?
    let rating: Double?
    let address: String
    let lat: Double
    let lon: Double
    let category: String?
    var isSaved: Bool? = false
    var historyId: Int? = nil

    enum CodingKeys: String, CodingKey {
        case id = "yelp_id"
        case name
        case imageUrl = "image_url"
        case rating
        case address
        case lat = "latitude"
        case lon = "longitude"
        case category
        case isSaved = "is_saved"
        case historyId = "history_id"
    }
}

struct RestaurantUIModel: Identifiable {
    let id = UUID().uuidString
    let name: String
    let address: String
    let imageUrl: String?
    let rating: Double?
    let yelpId: String?
    let isCustom: Bool

    var isSaved: Bool = false
    var historyId: Int? = nil
}

struct HistoryModel: Codable {
    let id: Int
    let yelpId: String?
    let isCustom: Bool
    let name: String
    let address: String
    let imageUrl: String?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case yelpId = "yelp_id"
        case isCustom = "is_custom"
        case name = "restaurant_name"
        case address
        case imageUrl = "image_url"
        case rating
    }
}

struct RequestInfoModel {
    let category: String
    let latitude: Double
    let longitude: Double
}

