//
//  GeneratorViewModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 3/24/26.
//

import UIKit
//import Foundation

protocol GeneratorViewModelDelegate: AnyObject {
    func goToHome()
}

class GeneratorViewModel {

    weak var delegate: GeneratorViewModelDelegate?

    let cuisineList:[String]

    init(cuisineList: [String]) {
        self.cuisineList = cuisineList
    }

    func randomResult()->String{
        guard let result = cuisineList.randomElement() else { return "None"}
        return result
    }

    func moveToHome() {
        delegate?.goToHome()
    }
}

