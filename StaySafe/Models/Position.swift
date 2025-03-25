//
//  Position.swift
//  StaySafe
//
//  Created by Heet Patel on 26/02/2025.
//
import Foundation

struct Position: Codable, Identifiable {
    var id: Int? { positionID } // ID can be nil when posting a new position
    
    let positionID: Int?
    let positionActivityID: Int
    let positionLatitude: Double
    let positionLongitude: Double
    let positionTimestamp: Int
    let positionActivityName: String

    enum CodingKeys: String, CodingKey {
        case positionID = "PositionID"
        case positionActivityID = "PositionActivityID"
        case positionLatitude = "PositionLatitude"
        case positionLongitude = "PositionLongitude"
        case positionTimestamp = "PositionTimestamp"
        case positionActivityName = "PositionActivityName"
    }
}
