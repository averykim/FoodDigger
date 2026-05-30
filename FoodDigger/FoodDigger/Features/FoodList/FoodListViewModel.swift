//
//  FoodListViewModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/29.
//

import Foundation
import CoreLocation

class FoodListViewModel {

    //coordinator closures
    var navigateToHome: (()->Void)?
    var navigateToRandomView: (([RestaurantUIModel]) -> Void)?
    var navigateToMapModal: ((String) -> Void)?

    //View closures
    var onRestaurantsUpdated: (() -> Void)?

    let cuisine: String
    let network = APIClient()

    private(set) var restaurants: [RestaurantUIModel] = [] {
        didSet {
            onRestaurantsUpdated?()
        }
    }


    init(cuisine: String) {
        self.cuisine = cuisine
    }

    func moveToCuisineListView() {
        navigateToHome?()
    }

    func moveToMapView() {
        navigateToMapModal?(cuisine)
    }

    func moveToGeneratorView() {
        navigateToRandomView?(restaurants)
    }

    func addSelectedMarkerInfo(markers: [RestaurantModel]) {
        for marker in markers {
            if !restaurants.contains(where: { $0.yelpId == marker.id }) {
                let newItem = RestaurantUIModel(name: marker.name,
                                                address: marker.address,
                                                imageUrl: marker.imageUrl,
                                                rating: marker.rating,
                                                yelpId: marker.id,
                                                isCustom: false,
                                                isSaved: marker.isSaved ?? false)
                restaurants.append(newItem)
            }
        }
    }

    func addRestaurant(name: String) {
        let customRestaurant = RestaurantUIModel(name: name,
                                                 address: "",
                                                 imageUrl: nil,
                                                 rating: 0.0,
                                                 yelpId: nil,
                                                 isCustom: true,
                                                 isSaved: false)
        restaurants.append(customRestaurant)
    }

    func deleteRestaurant(at index: Int) {
        restaurants.remove(at: index)
    }

    private var saveTasks: [String: Task<Void, Never>] = [:]

    func toggleSave(at index: Int) {
        restaurants[index].isSaved.toggle()

        let targetId = restaurants[index].id

        saveTasks[targetId]?.cancel()

        saveTasks[targetId] = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)

            if Task.isCancelled {return}

            guard let currentIndex = self.restaurants.firstIndex(where: {$0.id == targetId}) else {return}
            let finalTarget = self.restaurants[currentIndex]

            if finalTarget.isSaved {
                do {
                    let savedData = try await HistoryService().saveToHistory(item: finalTarget)
                    if let index = self.restaurants.firstIndex(where: {$0.id == targetId}) {
                        self.restaurants[index].historyId = savedData.id
                    }
                } catch {
                    self.restaurants[currentIndex].isSaved = false
                }
            } else {
                do {
                    guard finalTarget.yelpId != nil || finalTarget.historyId != nil else {return}
                    let _ = try await HistoryService().deleteHistory(yelpId: finalTarget.yelpId, historyId: finalTarget.historyId)
                    if let index = self.restaurants.firstIndex(where: {$0.id == targetId}) {
                        self.restaurants[index].historyId = nil
                    }

                } catch {
                    self.restaurants[currentIndex].isSaved = true
                }
            }
        }//Task

    }
}
