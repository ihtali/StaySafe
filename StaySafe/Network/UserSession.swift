//
//  UserSession.swift
//  StaySafe
//
//  Created by Heet Patel on 05/03/2025.
//
import Foundation

class UserSession: ObservableObject {
    @Published var userID: String = "2"
    @Published var isLoggedIn: Bool = false // Track login state
    @Published var userImage: String? = nil // Store user profile image URL

    func logout() {
        userID = ""  // Clear user ID
        userImage = nil // Clear user image
        isLoggedIn = false  // Set login state to false
    }

    static let shared = UserSession()
}
