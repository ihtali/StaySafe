//
//  User.swift
//  StaySafe
//
//  Created by Heet Patel on 26/02/2025.
//

import Foundation

struct User: Codable {
    let userID: String
    let firstName: String
    let lastName: String
    let phone: String
    let latitude: Double
    let longitude: Double
}
