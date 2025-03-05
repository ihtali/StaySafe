//
//  ActivityDeatils.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 28/02/2025.
//
import SwiftUI

struct ActivityCreationView: View {
    @State private var activityName: String = ""
    @State private var description: String = ""
    @State private var departure: String = ""
    @State private var destination: String = ""
    @State private var departureTime: Date = Date()
    @State private var arrivalTime: Date = Date()

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Activity Details")) {
                    TextField("Activity Name", text: $activityName)
                    TextField("Description", text: $description)
                    TextField("Departure Location", text: $departure)
                    TextField("Destination Location", text: $destination)
                    DatePicker("Departure Time", selection: $departureTime, displayedComponents: .hourAndMinute)
                    DatePicker("Arrival Time", selection: $arrivalTime, displayedComponents: .hourAndMinute)
                }
            }

            HStack {
                Button("Cancel") {
                    // Cancel action
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Save") {
                    // Save action
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Create New Activity")
    }
}

