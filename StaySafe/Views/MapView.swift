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
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        VStack {
            Map(coordinateRegion: $region)
                .edgesIgnoringSafeArea(.all)

            HStack {
                Button("Back") {
                    // Back action
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Refresh") {
                    // Refresh action
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Map")
    }
}

////
