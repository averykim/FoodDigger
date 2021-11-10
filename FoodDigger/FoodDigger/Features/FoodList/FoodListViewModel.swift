//
//  FoodListViewModel.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/29.
//

import Foundation

protocol FoodListViewModelDelegate: AnyObject {
    func goToCuisineListView()
    func goToMapModal(info: [MapInfoModel])
}

class FoodListViewModel {

    weak var delegate: FoodListViewModelDelegate?

    let cuisineName: String
    let network = Network()
    let privateKey = PrivateKey()
    var restaurantInfo: [MapInfoModel]
    var selectedRestaurant: [String]

    init(cuisine: String) {
        self.cuisineName = cuisine
        restaurantInfo = []
        selectedRestaurant = []
    }

    func callYelpAPI() {
        // WIP: Change latitude and longitude
        let urlComponents = NSURLComponents(string: "https://api.yelp.com/v3/businesses/search?")
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: "37.786882"),
            URLQueryItem(name: "longitude", value: "-122.399972"),
            URLQueryItem(name: "radius", value: "2000"),
            URLQueryItem(name: "term", value: cuisineName)
        ]
        guard let yelpURL = urlComponents?.url else {
            return
        }
        var request = URLRequest(url: yelpURL)
        request.setValue("Bearer \(privateKey.yelpApi)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        network.send(request) { (result: Result<YelpModel, Error>) in
            do {
                let data = try result.get()
                for restaurant in data.businesses {
                    self.restaurantInfo.append(MapInfoModel(id: restaurant.id,
                                                            name: restaurant.name,
                                                            latitude: restaurant.coordinates.latitude ?? 0.0,
                                                            logitude: restaurant.coordinates.longitude ?? 0.0))
                }
            } catch {
                print("error: \(error)")
            }
        }
    }

    func callKakaoAPI() {
        //WIP: Change y and x
        let urlComponents = NSURLComponents(string: "https://dapi.kakao.com/v2/local/search/keyword.json?")
        urlComponents?.queryItems = [
            URLQueryItem(name: "y", value: "37.514322572335935"),
            URLQueryItem(name: "x", value: "127.06283102249932"),
            URLQueryItem(name: "radius", value: "2000"),
            URLQueryItem(name: "query", value: NSLocalizedString(cuisineName, comment: ""))
        ]
        guard let kakaoURL = urlComponents?.url else {
            return
        }
        var request = URLRequest(url: kakaoURL)
        request.setValue(privateKey.kakaoApi, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        network.send(request) { (result: Result<KakaoModel, Error>) in
            do {
                let data = try result.get()
                print("data count: \(data.documents.count)")
                for restaurant in data.documents {
                    self.restaurantInfo.append(MapInfoModel(id: restaurant.id,
                                                            name: restaurant.place_name,
                                                            latitude: Double(restaurant.x ?? "") ?? 0.0,
                                                            logitude: Double(restaurant.y ?? "") ?? 0.0))
                }
            } catch {
                print("error: \(error)")
            }
        }
    }

    func moveToCuisineListView() {
        delegate?.goToCuisineListView()
    }

    func moveToMapView() {
        delegate?.goToMapModal(info: restaurantInfo)
    }

    func addMenu(text: String?) {
        guard text != "", let menu = text else {
            return
        }
        selectedRestaurant.append(menu)
    }
}
