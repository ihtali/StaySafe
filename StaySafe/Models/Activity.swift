//
//  Activity.swift
//  StaySafe
//
//  Created by Heet Patel on 26/02/2025.
//

import Foundation

struct Activity: Codable {
    let activityID: String
    let userID: String
    let startTime: String
    let endTime: String?
    let status: String
}
