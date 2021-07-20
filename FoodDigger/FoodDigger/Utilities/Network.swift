//
//  Network.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/07/20.
//

import Foundation

class Network {
    static let shared = Network()
    let session: URLSession = URLSession(configuration: .default)

    func send<T: CommonModel>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            var result: Result<T, Error>
            guard let httpResponse = response as? HTTPURLResponse else { return }
            //check error
            if let error = error, (400...500).contains(httpResponse.statusCode){
                result = .failure(error)
                completion(result)
            }

            if let data = data, (200...299).contains(httpResponse.statusCode) {
                do {
                    let decoder = JSONDecoder()
                    result = .success(try decoder.decode(T.self, from: data))
                } catch {
                    result = .failure(error)
                }
                completion(result)
            }
        }
        task.resume()
    }
}
