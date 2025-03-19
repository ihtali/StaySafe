//
//  UserView.swift
//  StaySafe
//
//  Created by Heet Patel on 26/02/2025.
//
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
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        ProgressView("Loading user data...")
                            .padding()
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else if let user = user {
                        VStack(spacing: 15) {
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
                                // Allow editing the name and phone number
                                TextField("First Name", text: $newFirstName)
                                    .padding()
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                TextField("Last Name", text: $newLastName)
                                    .padding()
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                TextField("Phone", text: $newPhone)
                                    .padding()
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            } else {
                                Text("\(user.firstName) \(user.lastName)")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Text(user.phone)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            // Edit Button
                            Button(action: {
                                if isEditing {
                                    // If we're in editing mode, update the user
                                    let updatedUser = User(
                                        userID: user.userID,
                                        firstName: newFirstName.isEmpty ? user.firstName : newFirstName,
                                        lastName: newLastName.isEmpty ? user.lastName : newLastName,
                                        phone: newPhone.isEmpty ? user.phone : newPhone, // Include the updated phone number
                                        latitude: user.latitude,
                                        longitude: user.longitude,
                                        imageURL: user.imageURL,
                                        username: user.username,
                                        password: user.password ?? "defaultPassword", // Use the current password or a default
                                        timestamp: user.timestamp
                                    )
                                    
                                    viewModel.updateUser(userID: user.userID, updatedUser: updatedUser) { success, errorMessage in
                                        if success {
                                            // Exit editing mode and dismiss the editing UI
                                            isEditing = false
                                            
                                            // Fetch the updated user data
                                            viewModel.fetchUser(userID: String(user.userID))
                                            
                                            // You may also want to update the local user object directly here to avoid waiting for the fetch
                                           
                                        } else {
                                            print(errorMessage ?? "Update failed")
                                        }
                                    }
                                } else {
                                    // Start editing
                                    newFirstName = user.firstName
                                    newLastName = user.lastName
                                    newPhone = user.phone // Populate the phone number field
                                    isEditing.toggle()
                                }
                            }) {
                                Text(isEditing ? "Save Changes" : "Edit")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(isEditing ? Color.green : Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.top)


                            // Delete Button
                            Button(action: {
                                deleteUser()
                            }) {
                                Text("Delete")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.top)
                        }
                        .padding()
                    } else {
                        Text("User not found")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("Profile")
            .onAppear {
                viewModel.fetchUser(userID: userSession.userID)
            }
            .onChange(of: viewModel.refreshTrigger) { _ in
                user = viewModel.user
            }
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
