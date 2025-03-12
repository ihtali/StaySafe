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
        guard let url = URL(string: "https://softwarehub.uk/unibase/staysafe/v1/api/users/contacts/\(userID)") else {
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

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response: \(jsonString)")  // 🔍 Debugging JSON output
                }

                // Try decoding as an array
                if let contactsArray = try? decoder.decode([Contact].self, from: data) {
                    DispatchQueue.main.async {
                        self.contacts = contactsArray
                    }
                } else {
                    // If decoding as an array fails, try decoding as a dictionary
                    let errorResponse = try decoder.decode([String: String].self, from: data)
                    if let message = errorResponse["message"] {
                        DispatchQueue.main.async {
                            self.errorMessage = message
                            self.contacts = []  // Ensure contacts list is empty
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                    print("Decoding error: \(error)")
                }
            }

        }.resume()
    }
}
