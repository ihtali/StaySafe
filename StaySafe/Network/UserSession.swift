//
//  UserSession.swift
//  StaySafe
//
//  Created by Heet Patel on 05/03/2025.
//

import Foundation

class UserSession: ObservableObject {
    @Published var userID: String = "1"
    @Published var baseURL: String = "https://softwarehub.uk/unibase/staysafe/v1/api"

    static let shared = UserSession() // Singleton instance
}
