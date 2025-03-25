//
//  ActivityCreationView.swift
//  StaySafe
//
//  Created by Heet Patel on 06/03/2025.
//

import SwiftUI

struct ActivityCreationView: View {
    @StateObject private var activityViewModel = ActivityViewModel()
    @StateObject private var locationViewModel = LocationViewModel()
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var selectedFromLocationID: Int?
    @State private var selectedToLocationID: Int?
    @State private var leaveDate = Date()
    @State private var arriveDate = Date()
    @State private var isSubmitting: Bool = false
    @Environment(\.presentationMode) var presentationMode // For navigating back
    @EnvironmentObject var userSession: UserSession

    var body: some View {
        Form {
            Section(header: Text("Activity Details")) {
                TextField("Activity Name", text: $name)
                TextField("Description", text: $description)
            }

            Section(header: Text("Select Locations")) {
                Picker("From Location", selection: $selectedFromLocationID) {
                    Text("Select a location").tag(nil as Int?) // Placeholder
                    ForEach(locationViewModel.locations, id: \.locationID) { location in
                        Text(location.name).tag(location.locationID as Int?)
                    }
                }

                Picker("To Location", selection: $selectedToLocationID) {
                    Text("Select a location").tag(nil as Int?)
                    ForEach(locationViewModel.locations, id: \.locationID) { location in
                        Text(location.name).tag(location.locationID as Int?)
                    }
                }
            }

            Section(header: Text("Time Details")) {
                DatePicker("Leave Time", selection: $leaveDate, displayedComponents: [.date, .hourAndMinute])
                DatePicker("Arrive Time", selection: $arriveDate, displayedComponents: [.date, .hourAndMinute])
            }

            Button(action: submitActivity) {
                HStack {
                    if isSubmitting {
                        ProgressView()
                    }
                    Text("Create Activity")
                }
            }
            .disabled(isSubmitting)
        }
        .navigationTitle("Create Activity")
        .onAppear {
            locationViewModel.fetchLocations()
        }
    }

    func formatToISO8601(date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC time
        return formatter.string(from: date)
    }

    func generateActivityID() -> Int {
        return Int.random(in: 101...99999) // Generates a unique ID > 100
    }

    func submitActivity() {
        guard let fromLocationID = selectedFromLocationID,
              let toLocationID = selectedToLocationID,
              !name.isEmpty,
              !description.isEmpty,
              let userID = Int(userSession.userID) else {
            return
        }

        isSubmitting = true

        let newActivity = Activity(
            activityID: generateActivityID(),
            name: name,
            userID: userID,
            description: description,
            fromLocationID: fromLocationID,
            fromLocationName: "",
            leaveTime: formatToISO8601(date: leaveDate),
            toLocationID: toLocationID,
            toLocationName: "",
            arriveTime: formatToISO8601(date: arriveDate),
            modeID: 1, // Default to 1 (e.g., Walking)
            modeName: "Walking",
            statusID: 1, // Default status ID "Planned"
            statusName: "Planned"
        )

        activityViewModel.createActivity(activity: newActivity) { success, errorMessage in
            DispatchQueue.main.async {
                isSubmitting = false
                if success {
                    presentationMode.wrappedValue.dismiss() // Navigate back to HomeView
                } else if let errorMessage = errorMessage {
                    print("Error: \(errorMessage)")
                }
            }
        }
    }
}
