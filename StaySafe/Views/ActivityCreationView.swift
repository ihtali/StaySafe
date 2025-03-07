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
    @State private var leaveTime: String = ""
    @State private var arriveTime: String = ""
    @State private var isSubmitting: Bool = false

    let userID: Int

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
                    TextField("Leave Time (YYYY-MM-DD HH:MM:SS)", text: $leaveTime)
                    TextField("Arrive Time (YYYY-MM-DD HH:MM:SS)", text: $arriveTime)
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

    func submitActivity() {
        guard let fromLocationID = selectedFromLocationID,
              let toLocationID = selectedToLocationID,
              let statusID = selectedStatusID,
              !name.isEmpty,
              !description.isEmpty,
              !leaveTime.isEmpty,
              !arriveTime.isEmpty else {
            return
        }

        isSubmitting = true

        let newActivity = Activity(
            activityID: 0,
            name: name,
            userID: userID,
            description: description,
            fromLocationID: fromLocationID,
            fromLocationName: "",
            leaveTime: leaveTime,
            toLocationID: toLocationID,
            toLocationName: "",
            arriveTime: arriveTime,
            statusID: statusID,
            statusName: ""
        )

        activityViewModel.createActivity(activity: newActivity) { success, errorMessage in
            DispatchQueue.main.async {
                isSubmitting = false
                if success {
                    // Dismiss or show success message
                } else if let errorMessage = errorMessage {
                    print("Error: \(errorMessage)")
                }
            }
        }
    }
}

#Preview {
    ActivityCreationView(userID: 1)
}
