//
//  APIManager.swift
//  StaySafe
//
//  Created by Heet Patel on 26/02/2025.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private let baseURL = "https://softwarehub.uk/unibase/staysafe/v1/api"

    func getUser(userID: String, completion: @escaping (Result<User, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/users/\(userID)") else {
            completion(.failure(.badURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Request error:", error.localizedDescription)
                completion(.failure(.requestFailed))
                return
            }

            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                   print("Raw JSON response: \(jsonString)")
               }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase  // 🔹 Ensures correct key conversion
                let user = try decoder.decode(User.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } catch {
                print("Decoding error:", error.localizedDescription)
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
