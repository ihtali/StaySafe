//
//  ContactViewModel.swift
//  StaySafe
//
//  Created by Heet Patel on 06/03/2025.
//
import Foundation

class ContactViewModel: ObservableObject {
    @Published var contacts: [Contact] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func fetchContacts(userID: String) {
        guard let url = URL(string: "https://softwarehub.uk/unibase/staysafe/v2/api/users/contacts/\(userID)") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
            }
            return
        }

        isLoading = true
        errorMessage = nil

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept") // Ensure correct content type

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            // Handle network errors
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                }
                return
            }

            // Check HTTP response status
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")  // Debugging
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.errorMessage = "Server error: \(httpResponse.statusCode)"
                    }
                    return
                }
            }

            // Ensure we have valid data
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }

            // Debug raw JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response: \(jsonString)") // Debugging
            }

            do {
                let decoder = JSONDecoder()
                let contactsArray = try decoder.decode([Contact].self, from: data)

                DispatchQueue.main.async {
                    self.contacts = contactsArray
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode contacts: \(error.localizedDescription)"
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }
}
