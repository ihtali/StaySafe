import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var userSession: UserSession
    @StateObject private var userViewModel = UserViewModel()

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phone = ""
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // App Logo or Title
                Text("StaySafe")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)
                    .padding(.top, 40)

                // Registration Form
                VStack(spacing: 16) {
                    // First Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("First Name")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                        TextField("Enter your first name", text: $firstName)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }

                    // Last Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Last Name")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                        TextField("Enter your last name", text: $lastName)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }

                    // Phone
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phone")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                        TextField("Enter your phone number", text: $phone)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.phonePad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }

                    // Username
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Username")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                        TextField("Enter your username", text: $username)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }

                    // Password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                        SecureField("Enter your password", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 24)

                // Register Button
                Button(action: registerUser) {
                    Text("Register")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .disabled(firstName.isEmpty || lastName.isEmpty || phone.isEmpty || username.isEmpty || password.isEmpty)
                .opacity(firstName.isEmpty || lastName.isEmpty || phone.isEmpty || username.isEmpty || password.isEmpty ? 0.6 : 1)
                .padding(.horizontal, 24)

                // Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer()
            }
            .padding()
        }
        .navigationBarHidden(true)
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }

    private func registerUser() {
        let newUser = User(
            userID: Int.random(in: 1000...9999), // Generate a random ID
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            latitude: 0.0,
            longitude: 0.0,
            imageURL: "https://static.generated.photos/vue-static/face-generator/landing/wall/13.jpg",
            username: username,
            password: password,
            timestamp: Int(Date().timeIntervalSince1970)
        )

        userViewModel.createUser(user: newUser) { success, error in
            if success {
                DispatchQueue.main.async {
                    userSession.userID = String(newUser.userID)
                    userSession.isLoggedIn = true
                }
            } else {
                errorMessage = error
            }
        }
    }
}
