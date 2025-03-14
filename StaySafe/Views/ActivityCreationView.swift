//
//  ActivityCreationView.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 05/03/2025.
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
        VStack(spacing: 0) {
            // Header Section
            Text("Create New Activity")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .shadow(radius: 5)

            // Form Section
            Form {
                Section(header: Text("Activity Details").font(.headline)) {
                    TextField("Activity Name", text: $activityName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Description", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Departure Location", text: $departure)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Destination Location", text: $destination)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    DatePicker("Departure Time", selection: $departureTime, displayedComponents: .hourAndMinute)
                    DatePicker("Arrival Time", selection: $arrivalTime, displayedComponents: .hourAndMinute)
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()

            // Buttons Section
            HStack(spacing: 20) {
                Button(action: {
                    // Cancel action
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }

                Button(action: {
                    // Save action
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
            .padding()
        }
        .navigationTitle("Create New Activity")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ActivityCreationView()
}
