//
//  CuisineViewModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/16.
//

import Foundation

protocol CuisineListViewModelDelegate: AnyObject {
    func goToHelpView()
    func goToFoodListView(cuisine: String)
}

class CuisineListViewModel {

    weak var delegate: CuisineListViewModelDelegate?

    var cuisines = [CuisineType: String]()
    subscript(type: CuisineType) -> String? {
        get {
            return cuisines[type]
        }
        set(newType) {
            return cuisines[type] = newType
        }
    }

    init() {
        for type in CuisineType.cases {
            cuisines[type] = NSLocalizedString(type.rawValue, comment: "")
        }
    }

    func changeCuisinesState(type: CuisineType) {
        if cuisines[type] != nil && cuisines.count != 1 {
            cuisines.removeValue(forKey: type)
        } else {
            cuisines[type] = NSLocalizedString(type.rawValue, comment: "")
        }
    }

    func moveToHelpView() {
        delegate?.goToHelpView()
    }

    func moveToFoodListView() {
        if let randomValue = cuisines.randomElement()?.value {
            delegate?.goToFoodListView(cuisine: randomValue)
        }
    }
}
