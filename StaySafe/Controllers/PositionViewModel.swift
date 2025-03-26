//
//  PositionViewModel.swift
//  StaySafe
//
//  Created by Heet Patel on 26/03/2025.
//

import Foundation
import CoreLocation

class PositionViewModel: ObservableObject {
    @Published var isPosting = false
    @Published var positions: [Position] = []
    private var timer: Timer?

    func startPostingLocation(for activityID: Int, name: String, locationManager: LocationManager) {
        stopPostingLocation() // Ensure no duplicate timers
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            guard let self = self, let currentLocation = locationManager.location else { return }
            self.postCurrentPosition(for: activityID, latitude: currentLocation.latitude, longitude: currentLocation.longitude, name: name)
        }
    }
    
    func stopPostingLocation() {
        timer?.invalidate()
        timer = nil
    }

    private func postCurrentPosition(for activityID: Int, latitude: Double, longitude: Double, name: String) {
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        let position = Position(
            positionID: nil,
            positionActivityID: activityID,
            positionLatitude: latitude,
            positionLongitude: longitude,
            positionTimestamp: currentTimestamp,
            positionActivityName: name
        )

        guard let url = URL(string: "https://softwarehub.uk/unibase/staysafe/v2/api/positions/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(position)
            request.httpBody = jsonData
        } catch {
            print("Error encoding position: \(error)")
            return
        }

        isPosting = true
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isPosting = false
            }

            if let error = error {
                print("Failed to post position: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("Server error: \(httpResponse.statusCode)")
                return
            }

            print("Position posted successfully!")
        }.resume()
    }

    /// Fetches all positions for a given activity ID
    func fetchPositions(for activityID: Int) {
        guard let url = URL(string: "https://softwarehub.uk/unibase/staysafe/v2/api/positions/activities/\(activityID)") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch positions: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decodedPositions = try JSONDecoder().decode([Position].self, from: data)
                DispatchQueue.main.async {
                    self.positions = decodedPositions
                }
            } catch {
                print("Error decoding positions: \(error)")
            }
        }.resume()
    }
}
