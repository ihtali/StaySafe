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
    @StateObject private var statusViewModel = StatusViewModel()
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var selectedFromLocationID: Int?
    @State private var selectedToLocationID: Int?
    @State private var selectedStatusID: Int?
    @State private var leaveDate = Date()
    @State private var arriveDate = Date()
    @State private var isSubmitting: Bool = false
    @Environment(\.presentationMode) var presentationMode // For navigating back
    @EnvironmentObject var userSession: UserSession

    //let userID: Int
    

    var body: some View {
        NavigationView {
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

                Section(header: Text("Select Status")) {
                    Picker("Status", selection: $selectedStatusID) {
                        Text("Select a status").tag(nil as Int?)
                        ForEach(statusViewModel.statuses, id: \.statusID) { status in
                            Text(status.name).tag(status.statusID as Int?)
                        }
                    }
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
                statusViewModel.fetchStatuses()
            }
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
              let statusID = selectedStatusID,
              !name.isEmpty,
              !description.isEmpty,
              let userID = Int(userSession.userID)else {
            return
        }

        isSubmitting = true

        let newActivity = Activity(
            activityID: generateActivityID(), // Use the function to get an ID > 100
            name: name,
            userID: userID,
            description: description,
            fromLocationID: fromLocationID,
            fromLocationName: "",
            leaveTime: formatToISO8601(date: leaveDate), // Convert to correct format
            toLocationID: toLocationID,
            toLocationName: "",
            arriveTime: formatToISO8601(date: arriveDate), // Convert to correct format
            statusID: statusID,
            statusName: ""
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
