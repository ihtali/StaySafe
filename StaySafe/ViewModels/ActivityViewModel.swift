//
//  ActivityViewModel.swift
//  StaySafe
//
//  Created by Heet Patel on 06/03/2025.
//

import Foundation

class ActivityViewModel: ObservableObject {
    @Published var activities: [Activity] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func fetchActivities(for userID: Int) {
        guard let url = URL(string: "https://softwarehub.uk/unibase/staysafe/v1/api/activities/users/\(userID)") else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Request error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response:", jsonString) // Debugging
            }

            do {
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = jsonResponse["message"] as? String, message == "No record(s) found" {
                    DispatchQueue.main.async {
                        self.activities = []
                    }
                    return
                }

                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let fetchedActivities = try decoder.decode([Activity].self, from: data)

                DispatchQueue.main.async {
                    self.activities = fetchedActivities
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
