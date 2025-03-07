import Foundation

class UserViewModel: ObservableObject {
    @Published var user: User?

    func fetchUser(userID: String) {
        guard let url = URL(string: "https://softwarehub.uk/unibase/staysafe/v1/api/users/\(userID)") else {
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

            // Debug: Print raw JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response:", jsonString)
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                // Decode as an array of Users
                let users = try decoder.decode([User].self, from: data)

                DispatchQueue.main.async {
                    // Assign only the first user
                    self.user = users.first
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }

}
