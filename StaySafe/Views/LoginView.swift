import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var enteredUserID: String = ""
    @State private var isNavigatingToRegistration: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // App Logo or Title
                Text("StaySafe")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)
                    .padding(.top, 40)

                Spacer()

                // User ID Input Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("User ID")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                    TextField("Enter your User ID", text: $enteredUserID)
                        .textFieldStyle(PlainTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 24)

                // Login Button
                Button(action: {
                    if !enteredUserID.isEmpty {
                        userSession.userID = enteredUserID
                        userSession.isLoggedIn = true
                    }
                }) {
                    Text("Login")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(enteredUserID.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .blue.opacity(0.2), radius: 5, x: 0, y: 3)
                }
                .disabled(enteredUserID.isEmpty)
                .padding(.horizontal, 24)

                // Register Button
                Button(action: {
                    isNavigatingToRegistration = true
                }) {
                    Text("Don’t have an account? Register")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.blue)
                        .underline()
                }
                .padding(.bottom, 40)
                .sheet(isPresented: $isNavigatingToRegistration) {
                    RegistrationView()
                        .environmentObject(userSession)
                }

                Spacer()
            }
            .navigationBarHidden(true)
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        }
    }
}
///
