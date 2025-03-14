//
//  ActivityDetailsView.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 05/03/2025.
//
import SwiftUI
import MapKit

struct ActivityDetailsView: View {
    let activity: Activity
    @StateObject private var locationViewModel = LocationViewModel()
    @State private var region: MKCoordinateRegion? // No default value

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Section
                Text("Activity Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    .shadow(radius: 5)

                // Activity Details Section
                VStack(alignment: .leading, spacing: 15) {
                    DetailRow(title: "Activity Name", value: activity.name)
                    DetailRow(title: "Description", value: activity.description)
                    DetailRow(title: "Leave Time", value: activity.leaveTime)
                    DetailRow(title: "Arrive Time", value: activity.arriveTime)
                    DetailRow(title: "Status", value: activity.statusName, isStatus: true)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)

                // Map Section
                if let location = locationViewModel.locations.first(where: { $0.locationID == activity.toLocationID }) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Destination Location")
                            .font(.headline)
                            .foregroundColor(.black)

                        Map(coordinateRegion: Binding(
                            get: { region ?? MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
                                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                            ) },
                            set: { region = $0 }
                        ), annotationItems: [location]) { location in
                            MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), tint: .blue)
                        }
                        .frame(height: 300)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                } else {
                    Text("Loading location...")
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
}

// Custom View for Detail Rows
struct DetailRow: View {
    let title: String
    let value: String
    var isStatus: Bool = false

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundColor(isStatus ? .blue : .black)
                .fontWeight(isStatus ? .bold : .regular)
        }
    }
}

