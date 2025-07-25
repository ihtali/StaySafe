import SwiftUI

struct UserView: View {
    @EnvironmentObject var userSession: UserSession
    @StateObject private var viewModel = UserViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var user: User? // Store user data
    @State private var isEditing: Bool = false // Flag to toggle editing mode
    @State private var newFirstName: String = ""
    @State private var newLastName: String = ""
    @State private var newPhone: String = "" // State for phone number editing

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Loading user data...")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.red)
                        .padding()
                } else if let user = user {
                    VStack(spacing: 20) {
                        // Profile Image
                        if let imageUrl = user.imageURL, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(.gray)
                            }
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray)
                        }

                        // User Info
                        if isEditing {
                            VStack(spacing: 16) {
                                TextField("First Name", text: $newFirstName)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )

                                TextField("Last Name", text: $newLastName)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )

                                TextField("Phone", text: $newPhone)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            .padding(.horizontal, 24)
                        } else {
                            Text("\(user.firstName) \(user.lastName)")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)

                            Text(user.phone)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.gray)
                        }

                        // Edit Button
                        Button(action: {
                            if isEditing {
                                let updatedUser = User(
                                    userID: user.userID,
                                    firstName: newFirstName.isEmpty ? user.firstName : newFirstName,
                                    lastName: newLastName.isEmpty ? user.lastName : newLastName,
                                    phone: newPhone.isEmpty ? user.phone : newPhone,
                                    latitude: user.latitude,
                                    longitude: user.longitude,
                                    imageURL: user.imageURL,
                                    username: user.username,
                                    password: user.password ?? "defaultPassword",
                                    timestamp: user.timestamp
                                )

                                viewModel.updateUser(userID: user.userID, updatedUser: updatedUser) { success, errorMessage in
                                    if success {
                                        isEditing = false
                                        viewModel.fetchUser(userID: String(user.userID))
                                    } else {
                                        print(errorMessage ?? "Update failed")
                                    }
                                }
                            } else {
                                newFirstName = user.firstName
                                newLastName = user.lastName
                                newPhone = user.phone
                                isEditing.toggle()
                            }
                        }) {
                            Text(isEditing ? "Save Changes" : "Edit")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 24)

                        // Delete Button
                        Button(action: {
                            deleteUser()
                        }) {
                            Text("Delete")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.red]), startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding()
                } else {
                    Text("User not found")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle(Text("User Profile"))
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.fetchUser(userID: userSession.userID)
        }
        .onChange(of: viewModel.refreshTrigger) { _ in
            user = viewModel.user
        }
    }

    private func deleteUser() {
        guard let userID = user?.userID else { return }

        viewModel.deleteUser(userID: userID) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    UserSession.shared.logout()
                    presentationMode.wrappedValue.dismiss()
                } else if let errorMessage = errorMessage {
                    print("Delete error: \(errorMessage)")
                }
            }
        }
    }
}
