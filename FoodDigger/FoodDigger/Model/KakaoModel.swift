//
//  KakaoModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/07/20.
//

import Foundation

struct KakaoModel: CommonModel {
    let documents: [AddressModel]

    struct AddressModel: Codable {
        let address_name: String
        let category_group_code: String
        let category_group_name: String
        let category_name: String
        let distance: String
        let id: String
        let phone: String
        let place_name: String
        let place_url: String
        let road_address_name: String
        let x: String
        let y: String
    }
}
