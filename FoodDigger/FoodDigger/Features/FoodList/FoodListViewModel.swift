//
//  FoodListViewModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/29.
//

import Foundation

protocol FoodListViewModelDelegate: AnyObject {
    func goToCuisineListView()
}

class FoodListViewModel {

    weak var delegate: FoodListViewModelDelegate?

    let cuisineName: String

    init(cuisine: String) {
        self.cuisineName = cuisine
    }

    func moveToCuisineListView() {
        delegate?.goToCuisineListView()
    }
}
