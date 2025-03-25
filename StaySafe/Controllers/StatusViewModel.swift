import Foundation

class StatusViewModel: ObservableObject {
    @Published var statuses: [Status] = []

    func fetchStatuses() {
        guard let url = URL(string: "https://softwarehub.uk/unibase/staysafe/v2/api/status") else {
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
                let decodedStatuses = try JSONDecoder().decode([Status].self, from: data)
                DispatchQueue.main.async {
                    self.statuses = decodedStatuses
                }
            } catch {
                print("Decoding error:", error.localizedDescription)
            }
        }.resume()
    }
}
