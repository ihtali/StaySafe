//
//  Contact.swift
//  StaySafe
//
//  Created by Heet Patel on 26/02/2025.
//

import Foundation

struct Contact: Codable, Identifiable , Equatable {
    var id: Int {
        userID
    }
    let userID: Int
    let userFirstName: String
    let userLastName: String
    let userPhone: String
    let userUserName: String
    let userPassword: String?
    let userLatitude: Double
    let userLongitude: Double
    let userTimeStamp: Int
    let userImage: String?
    let userContactID: Int
    let userContactLabel: String
    let userContactCreated: String

    enum CodingKeys: String, CodingKey {
        case userID = "UserID"
        case userFirstName = "UserFirstname"
        case userLastName = "UserLastname"
        case userPhone = "UserPhone"
        case userUserName = "UserUsername"
        case userPassword = "UserPassword"
        case userLatitude = "UserLatitude"
        case userLongitude = "UserLongitude"
        case userTimeStamp = "UserTimestamp"
        case userImage = "UserImageURL"
        case userContactID = "UserContactID"
        case userContactLabel = "UserContactLabel"
        case userContactCreated = "UserContactDatecreated"
        
    }
}

