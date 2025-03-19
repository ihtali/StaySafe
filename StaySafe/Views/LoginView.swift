import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var enteredUserID: String = ""
    @State private var isNavigatingToRegistration: Bool = false

    var body: some View {
        VStack {
            Text("Welcome to StaySafe")
                .font(.largeTitle)
                .padding()

            TextField("Enter User ID", text: $enteredUserID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()

            Button("Login") {
                if !enteredUserID.isEmpty {
                    userSession.userID = enteredUserID
                    userSession.isLoggedIn = true
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(enteredUserID.isEmpty)

            Button("Register New Account") {
                isNavigatingToRegistration = true
            }
            .padding()
            .foregroundColor(.blue)
            .background(Color.white)
            .cornerRadius(8)
            .sheet(isPresented: $isNavigatingToRegistration) {
                RegistrationView()
                    .environmentObject(userSession)
            }
        }
        .padding()
    }
}
