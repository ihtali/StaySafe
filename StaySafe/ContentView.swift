import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userSession: UserSession
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        
        LoginView()
    }
}

#Preview {
    ContentView()
}
