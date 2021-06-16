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
}
