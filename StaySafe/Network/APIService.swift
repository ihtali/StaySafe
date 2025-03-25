//
//  PositionAPIService.swift
//  StaySafe
//
//  Created by Heet Patel on 25/03/2025.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    private init() {} // Singleton pattern
    
    func postPosition(activityID: Int, position: Position, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://softwarehub.uk/unibase/staysafe/v2/api/positions/activities/\(activityID)") else {
            print("Invalid URL")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(position)
            request.httpBody = jsonData
        } catch {
            print("Error encoding JSON: \(error)")
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error)")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                completion(true)
            } else {
                print("Server error: \(response.debugDescription)")
                completion(false)
            }
        }.resume()
    }
}
