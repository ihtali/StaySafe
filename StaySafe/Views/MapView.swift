//
//  MapView.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 05/03/2025.
//
import MapKit
import SwiftUI

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278), // Default to London
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        VStack(spacing: 0) {
            // Map Section
            Map(coordinateRegion: $region)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Buttons Section
            HStack(spacing: 20) {
                Button(action: {
                    // Back action
                }) {
                    Text("Back")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple) // Updated color
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }

                Button(action: {
                    // Refresh action
                }) {
                    Text("Refresh")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue) // Updated color
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
            .padding()
            .background(Color(.systemBackground)) 
            .shadow(radius: 5)
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MapView()
}
