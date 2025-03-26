//
//  ActivityDetailsView.swift
//  StaySafe
//
//  Created by Heet Patel on 06/03/2025.
//

import SwiftUI
import MapKit

struct ActivityDetailsView: View {
    let activity: Activity
    @ObservedObject var locationManager = LocationManager()
    @StateObject private var locationViewModel = LocationViewModel()
    @StateObject private var statusViewModel = StatusViewModel()
    @StateObject private var positionViewModel = PositionViewModel()
    @State private var region: MKCoordinateRegion?
    @State private var showCamera = false
    @State private var activityImageURL: URL?
    @State private var selectedStatusID: Int?
    @State private var isUpdatingStatus = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Activity Name Section
                Text(activity.name)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)

                // Activity Details Section
                VStack(alignment: .leading, spacing: 15) {
                    DetailRow(title: "Description", value: activity.description)
                    DetailRow(title: "Leave Time", value: formatDate(activity.leaveTime))
                    DetailRow(title: "Arrive Time", value: formatDate(activity.arriveTime))

                    // Status Picker Section
                    // Status Picker Section
                    Picker("Status", selection: $selectedStatusID) {
                        ForEach(statusViewModel.statuses, id: \.statusID) { status in
                            Text(status.name).tag(status.statusID as Int?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedStatusID) { newValue in
                        updateActivityStatus()
                        
                        if let newStatusID = newValue {
                            if let startStatus = statusViewModel.statuses.first(where: { $0.name.lowercased() == "started" }),
                               newStatusID == startStatus.statusID {
                                startPostingPosition()
                            }
                            else if let stopStatus = statusViewModel.statuses.first(where: { ["paused", "cancelled", "completed"].contains($0.name.lowercased()) }),
                                    newStatusID == stopStatus.statusID {
                                stopPostingPosition()
                            }
                        }
                    }

                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)

                // Image Preview Section
                if let imageURL = activityImageURL {
                    VStack {
                        Text("Activity Image")
                            .font(.headline)
                        Image(uiImage: loadImage(from: imageURL))
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding()
                }

                // Capture Image Button
                Button(action: {
                    showCamera = true
                }) {
                    Text(activityImageURL == nil ? "Capture Image" : "Retake Image")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()

                // Map Section
                if let fromLocation = locationViewModel.locations.first(where: { $0.locationID == activity.fromLocationID }),
                   let toLocation = locationViewModel.locations.first(where: { $0.locationID == activity.toLocationID }) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("From & To Locations")
                            .font(.headline)
                            .foregroundColor(.primary)

                        Map(
                            coordinateRegion: Binding(
                                get: { region ?? MKCoordinateRegion(
                                    center: CLLocationCoordinate2D(
                                        latitude: (fromLocation.latitude + toLocation.latitude) / 2,
                                        longitude: (fromLocation.longitude + toLocation.longitude) / 2
                                    ),
                                    span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                                ) },
                                set: { region = $0 }
                            ),
                            annotationItems: [fromLocation, toLocation]
                        ) { location in
                            MapAnnotation(coordinate: CLLocationCoordinate2D(
                                latitude: location.latitude,
                                longitude: location.longitude
                            )) {
                                VStack {
                                    Text(location.name)
                                        .font(.caption)
                                        .padding(5)
                                        .background(Color.white)
                                        .cornerRadius(5)
                                        .shadow(radius: 3)
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(location.locationID == activity.fromLocationID ? .green : .blue)
                                        .font(.title)
                                }
                            }
                        }
                        .frame(height: 250)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                } else {
                    Text("Loading locations...")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle("Activity Details")
        .onAppear {
            locationViewModel.fetchLocations()
            statusViewModel.fetchStatuses()
            selectedStatusID = activity.statusID
            loadImageForActivity()
        }
        .sheet(isPresented: $showCamera) {
            CameraView { capturedURL in
                saveImageForActivity(imageURL: capturedURL)
            }
        }
    }

    // Function to start posting positions
    private func startPostingPosition() {
        guard let userLocation = locationManager.location else {
            print("User location not available")
            return
        }
        positionViewModel.startPostingLocation(for: activity.activityID, name: activity.name, locationManager: locationManager)
    }

    // Function to stop posting positions
    private func stopPostingPosition() {
        positionViewModel.stopPostingLocation()
    }
    // Function to update the activity status in the backend
    private func updateActivityStatus() {
        guard let newStatusID = selectedStatusID else { return }
        
        isUpdatingStatus = true
        
        let updatedActivity = Activity(
            activityID: activity.activityID,
            name: activity.name,
            userID: activity.userID,
            description: activity.description,
            fromLocationID: activity.fromLocationID,
            fromLocationName: activity.fromLocationName,
            leaveTime: activity.leaveTime,
            toLocationID: activity.toLocationID,
            toLocationName: activity.toLocationName,
            arriveTime: activity.arriveTime,
            modeID: activity.modeID,
            modeName: activity.modeName,
            statusID: newStatusID,
            statusName: statusViewModel.statuses.first(where: { $0.statusID == newStatusID })?.name ?? "Planned"
        )

        // Call ViewModel to update the activity
        ActivityViewModel().updateActivity(activity: updatedActivity) { success, errorMessage in
            DispatchQueue.main.async {
                isUpdatingStatus = false
                if !success {
                    print("Error updating status: \(errorMessage ?? "Unknown error")")
                }
            }
        }
    }

    // Function to format the date string (time first, then date)
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm yyyy-MM-dd" // Time first, then date
            return outputFormatter.string(from: date)
        } else {
            return dateString // Return original string if parsing fails
        }
    }

    // Load image from saved URL
    private func loadImage(from url: URL) -> UIImage {
        guard let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return UIImage(systemName: "photo")! // Default placeholder
        }
        return image
    }

    // Load stored image for the activity
    private func loadImageForActivity() {
        if let savedURL = UserDefaults.standard.string(forKey: "activityImage_\(activity.activityID)"),
           let url = URL(string: savedURL) {
            activityImageURL = url
        }
    }

    // Save captured image URL
    private func saveImageForActivity(imageURL: URL) {
        activityImageURL = imageURL
        UserDefaults.standard.setValue(imageURL.absoluteString, forKey: "activityImage_\(activity.activityID)")
    }
}
