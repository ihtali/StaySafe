//
//  Camera.swift
//  StaySafe
//
//  Created by Heet Patel on 19/03/2025.
//

import SwiftUI
import SwiftData

@Model
class Camera{
    var id: UUID
    var activityID: Int
    var imageURL: String?
    
    
    init(activityID: Int, imageURL: String? = nil){
        self.id = UUID()
        self.activityID = activityID
        self.imageURL = imageURL
    }
}
