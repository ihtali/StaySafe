//
//  MapView.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 05/03/2025.
//
import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var userSession: UserSession
    @StateObject private var viewModel = ContactViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278), // Default: London
        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
    )

    var body: some View {
        ZStack {
            // Map View
            Map(coordinateRegion: $region, annotationItems: viewModel.contacts) { contact in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: contact.userLatitude, longitude: contact.userLongitude)) {
                    VStack(spacing: 4) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                            .shadow(radius: 3)

                        Text(contact.userFirstName)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(4)
                            .shadow(radius: 2)
                    }
                }
            }
            .onAppear {
                viewModel.fetchContacts(userID: userSession.userID)
            }
            .onChange(of: viewModel.contacts) { _ in
                updateRegion()
            }

            // Loading Indicator
            if viewModel.isLoading {
                ProgressView("Loading contacts...")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .padding()
                    .background(Color(.systemBackground).opacity(0.9))
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }

            // Error Message
            if let errorMessage = viewModel.errorMessage {
                VStack {
                    Text("Error: \(errorMessage)")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.9))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.top, 40)
                    Spacer()
                }
            }
        }
    }

    // Function to calculate the average location
    private func updateRegion() {
        guard !viewModel.contacts.isEmpty else { return }

        let avgLatitude = viewModel.contacts.map { $0.userLatitude }.reduce(0, +) / Double(viewModel.contacts.count)
        let avgLongitude = viewModel.contacts.map { $0.userLongitude }.reduce(0, +) / Double(viewModel.contacts.count)

        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: avgLatitude, longitude: avgLongitude),
            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5) // Adjust zoom level
        )
    }
}
