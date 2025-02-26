//
//  APIManager.swift
//  StaySafe
//
//  Created by Heet Patel on 26/02/2025.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private let baseURL = "https://api.staysafe.com"  // Replace with actual API URL

    private func request<T: Decodable>(_ endpoint: String, method: String, body: Data? = nil, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(.badURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if error != nil {
                completion(.failure(.requestFailed))
                return
            }

            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }

    func get<T: Decodable>(_ endpoint: String, completion: @escaping (Result<T, APIError>) -> Void) {
        request(endpoint, method: "GET", completion: completion)
    }

    func post<T: Decodable>(_ endpoint: String, body: Data, completion: @escaping (Result<T, APIError>) -> Void) {
        request(endpoint, method: "POST", body: body, completion: completion)
    }
}
