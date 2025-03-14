//
//  Location.swift
//  StaySafe
//
//  Created by Heet Patel on 26/02/2025.
//

import Foundation

struct Location: Codable , Identifiable {
    var id: Int { locationID } // Conform to Identifiable

    let locationID: Int
    let name: String
    let description: String
    let address: String
    let postcode: String
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case locationID = "LocationID"
        case name = "LocationName"
        case description = "LocationDescription"
        case address = "LocationAddress"
        case postcode = "LocationPostcode"
        case latitude = "LocationLatitude"
        case longitude = "LocationLongitude"
    }
}
