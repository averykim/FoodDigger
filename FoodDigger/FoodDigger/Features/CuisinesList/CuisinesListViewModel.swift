//
//  CuisineViewModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/16.
//

import Foundation

protocol CuisinesListViewModelDelegate: AnyObject {
}

class CuisinesListViewModel {

    weak var delegate: CuisinesListViewModelDelegate?

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
        if cuisines[type] != nil {
            cuisines.removeValue(forKey: type)
        } else {
            cuisines[type] = NSLocalizedString(type.rawValue, comment: "")
        }
    }
}
