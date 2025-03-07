//
//  Status.swift
//  StaySafe
//
//  Created by Heet Patel on 05/03/2025.
//

import Foundation

struct Status: Codable {
    let statusID: Int
    let name: String
    let order: Int

    enum CodingKeys: String, CodingKey {
        case statusID = "StatusID"
        case name = "StatusName"
        case order = "StatusOrder"
    }
}
