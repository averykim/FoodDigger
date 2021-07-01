//
//  FoodListViewModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/29.
//

import Foundation

protocol FoodListViewModelDelegate: AnyObject {
}

class FoodListViewModel {

    weak var delegate: FoodListViewModelDelegate?

    let cuisineName: String

    init(cuisine: String) {
        self.cuisineName = cuisine
    }
}
