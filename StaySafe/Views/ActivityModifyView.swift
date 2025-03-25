//
//  ActivityModifyView.swift
//  StaySafe
//
//  Created by Heet Patel on 12/03/2025.
//

import SwiftUI

struct ActivityModifyView: View {
    @StateObject private var activityViewModel = ActivityViewModel()
    @StateObject private var locationViewModel = LocationViewModel()
    @StateObject private var statusViewModel = StatusViewModel()

    @State private var name: String
    @State private var description: String
    @State private var selectedFromLocationID: Int?
    @State private var selectedToLocationID: Int?
    @State private var selectedStatusID: Int?
    @State private var leaveDate: Date
    @State private var arriveDate: Date
    @State private var isSubmitting: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userSession: UserSession

    let activity: Activity // The activity being modified

    init(activity: Activity) {
        _name = State(initialValue: activity.name)
        _description = State(initialValue: activity.description)
        _selectedFromLocationID = State(initialValue: activity.fromLocationID)
        _selectedToLocationID = State(initialValue: activity.toLocationID)
        _selectedStatusID = State(initialValue: activity.statusID)
        _leaveDate = State(initialValue: ActivityModifyView.dateFromISO8601(activity.leaveTime))
        _arriveDate = State(initialValue: ActivityModifyView.dateFromISO8601(activity.arriveTime))
        self.activity = activity
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Activity Details")) {
                    TextField("Activity Name", text: $name)
                    TextField("Description", text: $description)
                }

                Section(header: Text("Select Locations")) {
                    Picker("From Location", selection: $selectedFromLocationID) {
                        Text("Select a location").tag(nil as Int?)
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

                Button(action: updateActivity) {
                    HStack {
                        if isSubmitting {
                            ProgressView()
                        }
                        Text("Update Activity")
                    }
                }
                .disabled(isSubmitting)
            }
            .navigationTitle("Modify Activity")
            .onAppear {
                locationViewModel.fetchLocations()
                statusViewModel.fetchStatuses()
            }
        }
    }

    func updateActivity() {
        guard let fromLocationID = selectedFromLocationID,
              let toLocationID = selectedToLocationID,
              let statusID = selectedStatusID,
              !name.isEmpty,
              !description.isEmpty else {
            return
        }

        isSubmitting = true

        let updatedActivity = Activity(
            activityID: activity.activityID,
            name: name,
            userID: activity.userID,
            description: description,
            fromLocationID: fromLocationID,
            fromLocationName: "",
            leaveTime: ActivityModifyView.formatToISO8601(date: leaveDate),
            toLocationID: toLocationID,
            toLocationName: "",
            arriveTime: ActivityModifyView.formatToISO8601(date: arriveDate),
            modeID: 1, // Default to 0 or nil (whichever the backend expects)
            modeName: "Walking",
            statusID: statusID,
            statusName: ""
        )

        activityViewModel.updateActivity(activity: updatedActivity) { success, errorMessage in
            DispatchQueue.main.async {
                isSubmitting = false
                if success {
                    presentationMode.wrappedValue.dismiss()
                } else if let errorMessage = errorMessage {
                    print("Error: \(errorMessage)")
                }
            }
        }
    }

    static func formatToISO8601(date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: date)
    }

    static func dateFromISO8601(_ isoString: String) -> Date {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: isoString) ?? Date()
    }
}
