//
//  GeneratorViewModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 3/24/26.
//

import UIKit

class GeneratorViewModel {

    var navigateToHome: (() -> Void)?
    var navigateToHistory: (() -> Void)?

    //view
    var onRandomResultUpdated: ((String) -> Void)?

    let restaurants:[RestaurantUIModel]
    var finalResult: RestaurantUIModel?

    init(restaurants: [RestaurantUIModel]) {
        self.restaurants = restaurants
    }

    func randomResult() {
        if let result = restaurants.randomElement() {
            finalResult = result
            onRandomResultUpdated?(result.name)
        } else {
            onRandomResultUpdated?("No candidate")
        }
    }

    func moveToHome() {
        navigateToHome?()
    }

    func moveToExternalMap() {
        guard let restaurant = finalResult else {return}

        if restaurant.isCustom || restaurant.address.isEmpty {
            navigateToHome?()
        }

        guard let encodedName = restaurant.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        //google map is installed
        let appURLString = "comgooglemaps://?q=\(encodedName)"
        //If google map is not installed
        let webURLString = "https://www.google.com/maps/search/?api=1&query=\(encodedName)"

        guard let appURL = URL(string: appURLString),
                let webURL = URL(string: webURLString) else { return }

        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }

    }
}

