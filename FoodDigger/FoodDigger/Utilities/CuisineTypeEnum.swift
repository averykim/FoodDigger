//
//  CuisineTypeEnum.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/22.
//

import Foundation

enum CuisineType: String {
    case korean
    case european
    case japanese
    case chinese
    case southeastAsian
    case vegan
    case dessert

    static let cases: [CuisineType] = [.korean, .european, .japanese,
                                       .chinese, .southeastAsian, .vegan, .dessert]
}
