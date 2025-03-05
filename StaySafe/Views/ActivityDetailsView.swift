//
//  ActivityDetailsView.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 05/03/2025.
//
import SwiftUI

struct ActivityDetailsView: View {
    var activityName: String = "Walking to Park"
    var description: String = "Morning walk"
    var departure: String = "Home"
    var destination: String = "Park"
    var departureTime: String = "10:00 AM"
    var arrivalTime: String = "11:00 AM"

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Activity Info")) {
                    Text("Name: \(activityName)")
                    Text("Description: \(description)")
                    Text("Departure: \(departure)")
                    Text("Destination: \(destination)")
                    Text("Departure Time: \(departureTime)")
                    Text("Arrival Time: \(arrivalTime)")
                }

                Section(header: Text("Status")) {
                    Picker("Status", selection: .constant("Started")) {
                        Text("Started").tag("Started")
                        Text("Completed").tag("Completed")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }

            HStack {
                Button("Edit") {
                    // Edit action
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Delete") {
                    // Delete action
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Activity Details")
    }
}
