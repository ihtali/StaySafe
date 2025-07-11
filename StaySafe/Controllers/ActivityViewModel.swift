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

    private let imageStorageKey = "activityImages"

    func fetchActivities(for userID: Int) {
        guard let url = URL(string: "https://softwarehub.uk/unibase/staysafe/v2/api/activities/users/\(userID)") else {
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

    func createActivity(activity: Activity, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "https://softwarehub.uk/unibase/staysafe/v2/api/activities") else {
            completion(false, "Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(activity)
            request.httpBody = jsonData
        } catch {
            completion(false, "Encoding error: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Request error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                completion(false, "No data received")
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response:", jsonString) // Debugging
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = jsonResponse?["message"] as? String, message == "Activity created successfully" {
                    DispatchQueue.main.async {
                        self.fetchActivities(for: activity.userID) // Refresh list after creation
                    }
                    completion(true, nil)
                } else {
                    completion(false, "Failed to create activity")
                }
            } catch {
                completion(false, "Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func deleteActivity(activityID: Int, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "https://softwarehub.uk/unibase/staysafe/v2/api/activities/\(activityID)") else {
            completion(false, "Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Request error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                completion(false, "No data received")
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response:", jsonString) // Debugging
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = jsonResponse?["message"] as? String, message == "Activity deleted successfully" {
                    DispatchQueue.main.async {
                        self.activities.removeAll { $0.activityID == activityID } // Remove from local list
                    }
                    completion(true, nil)
                } else {
                    completion(false, "Failed to delete activity")
                }
            } catch {
                completion(false, "Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func updateActivity(activity: Activity, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "https://softwarehub.uk/unibase/staysafe/v2/api/activities/\(activity.activityID)") else {
            completion(false, "Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(activity)
            request.httpBody = jsonData
        } catch {
            completion(false, "Encoding error: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Request error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                completion(false, "No data received")
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response:", jsonString) // Debugging
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = jsonResponse?["message"] as? String, message == "Activity updated successfully" {
                    DispatchQueue.main.async {
                        self.fetchActivities(for: activity.userID) // Refresh list after update
                    }
                    completion(true, nil)
                } else {
                    completion(false, "Failed to update activity")
                }
            } catch {
                completion(false, "Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
// Function to save image URL for an activity
    func saveImage(for activityID: Int, imageURL: String) {
        var storedImages = fetchImages(for: activityID) // Get existing images
        storedImages.append(imageURL) // Add new image
        
        var allImages = UserDefaults.standard.dictionary(forKey: imageStorageKey) as? [String: [String]] ?? [:]
        allImages[String(activityID)] = storedImages
        UserDefaults.standard.setValue(allImages, forKey: imageStorageKey)
    }

    // Function to fetch all images for a given activity ID
    func fetchImages(for activityID: Int) -> [String] {
        let allImages = UserDefaults.standard.dictionary(forKey: imageStorageKey) as? [String: [String]] ?? [:]
        return allImages[String(activityID)] ?? []
    }
}
