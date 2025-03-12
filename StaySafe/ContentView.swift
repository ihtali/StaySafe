import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userSession: UserSession

    var body: some View {
        if userSession.isLoggedIn {
            TabNavigator()
        } else {
            LoginView()
        }
    }
}
