import Foundation

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let baseURL = "https://softwarehub.uk/unibase/staysafe/v1/api"

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

                // Debug: Print raw JSON response
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response: \(jsonString)")
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let users = try decoder.decode([User].self, from: data) // Decode as an array
                    
                    if let firstUser = users.first { // Extract first user
                        self?.user = firstUser
                    } else {
                        self?.errorMessage = "No user found"
                    }
                } catch {
                    self?.errorMessage = "Decoding error: \(error.localizedDescription)"
                }

            }
        }.resume()
    }
    
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

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response:", jsonString) // Debugging
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = jsonResponse?["message"] as? String, message == "User created successfully" {
                    DispatchQueue.main.async {
                        self?.fetchUser(userID: String(user.userID)) // Fetch newly created user
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
            let jsonData = try JSONEncoder().encode(updatedUser)
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

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response:", jsonString) // Debugging
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = jsonResponse?["message"] as? String, message == "User updated successfully" {
                    DispatchQueue.main.async {
                        self?.fetchUser(userID: String(userID)) // Refresh user data after update
                    }
                    completion(true, nil)
                } else {
                    completion(false, "Failed to update user")
                }
            } catch {
                completion(false, "Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }

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

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response:", jsonString) // Debugging
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = jsonResponse?["message"] as? String, message == "User deleted successfully" {
                    DispatchQueue.main.async {
                        self?.user = nil // Clear the user data after deletion
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
