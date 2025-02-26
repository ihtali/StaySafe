//
//  MockAPIManager.swift
//  StaySafe
//
//  Created by Heet Patel on 26/02/2025.
//

import Foundation

class MockAPIManager {
    static let shared = MockAPIManager()

    func getUser(userID: String, completion: @escaping (Result<User, APIError>) -> Void) {
        let mockUser = User(userID: userID, firstName: "John", lastName: "Doe", phone: "+123456789", latitude: 51.5074, longitude: -0.1278)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(mockUser))
        }
    }
}
