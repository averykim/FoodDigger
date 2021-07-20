//
//  YelpModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/07/20.
//

import Foundation

struct YelpModel: CommonModel {
    let businesses: [BusinessModel]

    struct BusinessModel: Codable {
        var id: String
        var alias: String
        var name: String
        var image_url: String
        var is_closed: Bool
        var url: String
        var review_count: Int
        var categories: [CategoryModel]
        var rating: Float
        var coordinates: CoordinatorModel
        var transactions: [String]
        var price: String?
        var location: LocationModel
        var phone: String
        var display_phone: String
        var distance: Double
    }

    struct CategoryModel: Codable {
        var alias: String
        var title: String
    }

    struct LocationModel: Codable {
        var address1: String
        var address2: String?
        var address3: String?
        var city: String
        var zip_code: String
        var country: String
        var state: String
        var display_address: [String]
    }

    struct CoordinatorModel: Codable {
        var latitude: Double
        var longitude: Double
    }
}
