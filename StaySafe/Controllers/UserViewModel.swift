import Foundation

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var users: [User] = []
    @Published var refreshTrigger = false // Forces UI update

    private let baseURL = "https://softwarehub.uk/unibase/staysafe/v2/api"

    // Fetch a single user by ID
    func fetchUser(userID: String) {
        guard let url = URL(string: "\(baseURL)/users/\(userID)") else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false

                if let error = error {
                    self?.errorMessage = "Request error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let users = try decoder.decode([User].self, from: data) // Decode as an array
                    
                    if let firstUser = users.first {
                        self?.user = firstUser
                        self?.refreshTrigger.toggle() // 🔄 Forces SwiftUI to refresh
                    } else {
                        self?.errorMessage = "No user found"
                    }
                } catch {
                    self?.errorMessage = "Decoding error: \(error.localizedDescription)"
                }

            }
        }.resume()
    }

    // Create a new user
    func createUser(user: User, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(baseURL)/users") else {
            completion(false, "Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            completion(false, "Encoding error: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                completion(false, "Request error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                completion(false, "No data received")
                return
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = jsonResponse?["message"] as? String, message == "User created successfully" {
                    DispatchQueue.main.async {
                        self?.fetchUser(userID: String(user.userID)) // Fetch new user data
                        self?.refreshTrigger.toggle()
                    }
                    completion(true, nil)
                } else {
                    completion(false, "Failed to create user")
                }
            } catch {
                completion(false, "Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
   
    func updateUser(userID: Int, updatedUser: User, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(baseURL)/users/\(userID)") else {
            completion(false, "Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            // Create a mutable copy of the updatedUser object
            var userToUpdate = updatedUser
            
            // If the password is empty, use a default password
            if userToUpdate.password?.isEmpty ?? true {
                userToUpdate.password = "defaultPassword" // Provide a default password
            }

            // Ensure the password is not empty
            guard let password = userToUpdate.password, !password.isEmpty else {
                completion(false, "Password cannot be empty")
                return
            }

            // Update fields such as first name, last name, etc.
            userToUpdate.firstName = updatedUser.firstName
            userToUpdate.lastName = updatedUser.lastName

            // Encode the updated user object
            let jsonData = try JSONEncoder().encode(userToUpdate)

            // Debug: Print JSON before sending
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("Sending JSON: \(jsonString ?? "No valid JSON")")

            request.httpBody = jsonData
        } catch {
            completion(false, "Encoding error: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Request error: \(error.localizedDescription)") // Debug print
                    completion(false, "Request error: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("No data received") // Debug print
                    completion(false, "No data received")
                    return
                }

                // Debug: Print server response
                let responseString = String(data: data, encoding: .utf8)
                print("Server Response: \(responseString ?? "No response")")

                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let message = jsonResponse?["message"] as? String, message == "User updated successfully" {
                        // Refresh user data after update
                        self?.fetchUser(userID: String(userID))
                        self?.refreshTrigger.toggle()
                        completion(true, nil)
                    } else {
                        print("Failed to update user: \(jsonResponse ?? [:])") // Debug print
                        completion(false, "Failed to update user")
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)") // Debug print
                    completion(false, "Decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    

    // Delete user
    func deleteUser(userID: Int, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(baseURL)/users/\(userID)") else {
            completion(false, "Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                completion(false, "Request error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                completion(false, "No data received")
                return
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = jsonResponse?["message"] as? String, message == "User deleted successfully" {
                    DispatchQueue.main.async {
                        self?.user = nil
                        self?.refreshTrigger.toggle()
                    }
                    completion(true, nil)
                } else {
                    completion(false, "Failed to delete user")
                }
            } catch {
                completion(false, "Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
}
