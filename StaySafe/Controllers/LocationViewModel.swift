//
//  LocationViewModel.swift
//  StaySafe
//
//  Created by Heet Patel on 06/03/2025.
//

import Foundation

class LocationViewModel: ObservableObject {
    @Published var locations: [Location] = []

    func fetchLocations() {
        guard let url = URL(string: "https://softwarehub.uk/unibase/staysafe/v1/api/locations") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Request error:", error.localizedDescription)
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decodedLocations = try JSONDecoder().decode([Location].self, from: data)
                DispatchQueue.main.async {
                    self.locations = decodedLocations
                }
            } catch {
                print("Decoding error:", error.localizedDescription)
            }
        }.resume()
    }
}
