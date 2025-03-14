//
//  Position.swift
//  StaySafe
//
//  Created by Heet Patel on 26/02/2025.
//
import Foundation

struct Position: Codable, Identifiable {
    var id: Int { positionID } // Conform to Identifiable

    let positionID: Int
    let activityID: Int
    let activityName: String
    let latitude: Double
    let longitude: Double
    let timestamp: Int

    enum CodingKeys: String, CodingKey {
        case positionID = "PositionID"
        case activityID = "PositionActivityID"
        case activityName = "PositionActivityName"
        case latitude = "PositionLatitude"
        case longitude = "PositionLongitude"
        case timestamp = "PositionTimestamp"
    }
}
