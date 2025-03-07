//
//  ActivityDetailsView.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 05/03/2025.
//
import SwiftUI

struct ActivityDetailsView: View {
    var activity: Activity  // Passed from HomeView
    
    var body: some View {
        ScrollView {  // Use ScrollView in case the content overflows
            VStack(alignment: .leading, spacing: 20) {
                Text("Activity Details")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Displaying all the properties from the Activity struct
                Text("Activity Name: \(activity.name)")
                    .font(.headline)
                
                Text("Description: \(activity.description)")
                    .font(.body)
                
                Text("From Location: \(activity.fromLocationName)")
                    .font(.body)
                
                Text("Leave Time: \(activity.leaveTime)")
                    .font(.body)
                
                Text("To Location: \(activity.toLocationName)")
                    .font(.body)
                
                Text("Arrive Time: \(activity.arriveTime)")
                    .font(.body)
                
                Text("Status: \(activity.statusName)")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Activity Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

