//
//  ActivityDetailsView.swift
//  StaySafe
//
//  Created by Heet Patel on 20/03/2025.
//

import SwiftUI
import MapKit
 
struct ActivityDetailsView: View {
    let activity: Activity
    @StateObject private var locationViewModel = LocationViewModel()
    @State private var region: MKCoordinateRegion?

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
                VStack(alignment: .leading, spacing: 16) {
                    DetailRow(title: "Description", value: activity.description)
                    DetailRow(title: "Leave Time", value: formatDate(activity.leaveTime))
                    DetailRow(title: "Arrive Time", value: formatDate(activity.arriveTime))
                    DetailRow(title: "Status", value: activity.statusName, isStatus: true)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)

 

                // Map Section
                if let fromLocation = locationViewModel.locations.first(where: { $0.locationID == activity.fromLocationID }),
                   let toLocation = locationViewModel.locations.first(where: { $0.locationID == activity.toLocationID }) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("From & To Locations")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
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
                            MapMarker(
                                coordinate: CLLocationCoordinate2D(
                                    latitude: location.latitude,
                                    longitude: location.longitude
                                ),
                                tint: location.locationID == activity.fromLocationID ? .green : .blue
                            )
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
                    ProgressView("Loading locations...")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle("Activity Details")
        .onAppear {
            locationViewModel.fetchLocations()
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
}

