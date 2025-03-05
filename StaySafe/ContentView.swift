import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        VStack {
            if let user = viewModel.user {
                Text("Name: \(user.firstName) \(user.lastName)")
                Text("Phone: \(user.phone)")
            } else {
                Text("Loading...")
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchUser(userID: "3") // Fetch user with ID 1
        }
    }
}

#Preview {
    ContentView()
}
