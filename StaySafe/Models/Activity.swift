//
//  Activity.swift
//  StaySafe
//
//  Created by Heet Patel on 26/02/2025.
//

import Foundation

struct Activity: Codable, Identifiable {
    var id: Int { activityID }
    
    let activityID: Int
    let name: String
    let userID: Int
    let description: String
    let fromLocationID: Int
    let fromLocationName: String
    let leaveTime: String
    let toLocationID: Int
    let toLocationName: String
    let arriveTime: String
    let statusID: Int
    let statusName: String
    
    enum CodingKeys: String, CodingKey {
        case activityID = "ActivityID"
        case name = "ActivityName"
        case userID = "ActivityUserID"
        case description = "ActivityDescription"
        case fromLocationID = "ActivityFromID"
        case fromLocationName = "ActivityFromName"
        case leaveTime = "ActivityLeave"
        case toLocationID = "ActivityToID"
        case toLocationName = "ActivityToName"
        case arriveTime = "ActivityArrive"
        case statusID = "ActivityStatusID"
        case statusName = "ActivityStatusName"
    }
}
