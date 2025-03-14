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

    func fetchContacts() {
        guard let url = URL(string: "https://softwarehub.uk/unibase/staysafe/v1/api/users/contacts/1") else {
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

            // Check for valid HTTP response status code
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                DispatchQueue.main.async {
                    self.errorMessage = "Server error: \(httpResponse.statusCode)"
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
                let fetchedContacts = try decoder.decode([Contact].self, from: data)

                DispatchQueue.main.async {
                    self.contacts = fetchedContacts
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
