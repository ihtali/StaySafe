import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var userSession: UserSession
    @StateObject private var userViewModel = UserViewModel()

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phone = ""
    @State private var username = ""
    @State private var password = ""
    @State private var latitude = 0.0
    @State private var longitude = 0.0
    @State private var imageURL = "https://static.generated.photos/vue-static/face-generator/landing/wall/13.jpg"
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)
                .padding()

            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Phone", text: $phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.phonePad)
                .padding()

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Register") {
                let newUser = User(
                    userID: Int.random(in: 1000...9999), // Generate a random ID
                    firstName: firstName,
                    lastName: lastName,
                    phone: phone,
                    latitude: latitude,
                    longitude: longitude,
                    imageURL: imageURL,
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
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(firstName.isEmpty || lastName.isEmpty || phone.isEmpty || username.isEmpty || password.isEmpty)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
}
