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
    let network = Network()
    let privateKey = PrivateKey()

    init(cuisine: String) {
        self.cuisineName = cuisine
    }

    func callYelpAPI() {
        // WIP: Change latitude and longitude
        let urlComponents = NSURLComponents(string: "https://api.yelp.com/v3/businesses/search?")
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: "37.786882"),
            URLQueryItem(name: "longitude", value: "-122.399972"),
            URLQueryItem(name: "radius", value: "20000"),
            URLQueryItem(name: "term", value: cuisineName)
        ]
        guard let yelpURL = urlComponents?.url else {
            return
        }
        var request = URLRequest(url: yelpURL)
        request.setValue("Bearer \(privateKey.yelpApi)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        network.send(request) { (result: Result<YelpModel, Error>) in
            print("data: \(result)")
        }
    }

    func callKakaoAPI() {
        //WIP: Change y and x
        let urlComponents = NSURLComponents(string: "https://dapi.kakao.com/v2/local/search/keyword.json?")
        urlComponents?.queryItems = [
            URLQueryItem(name: "y", value: "37.514322572335935"),
            URLQueryItem(name: "x", value: "127.06283102249932"),
            URLQueryItem(name: "radius", value: "20000"),
            URLQueryItem(name: "query", value: cuisineName)
        ]
        guard let kakaoURL = urlComponents?.url else {
            return
        }
        var request = URLRequest(url: kakaoURL)
        request.setValue(privateKey.kakaoApi, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        network.send(request) { (result: Result<KakaoModel, Error>) in
            print("data: \(result)")
        }

    }

    func moveToCuisineListView() {
        delegate?.goToCuisineListView()
    }
}
