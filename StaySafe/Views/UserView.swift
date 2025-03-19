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
    @State private var navigateToEdit = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Loading user data...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if let user = viewModel.user {
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
                        Text("\(user.firstName) \(user.lastName)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            DetailRow(title: "Username", value: user.lastName)
                            DetailRow(title: "Phone", value: user.phone)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        

                        HStack(spacing: 20) {
                            Button(action: {
                                navigateToEdit = true
                            }) {
                                Text("Modify")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            NavigationLink(
                                destination: EditUserView(user: user, viewModel: viewModel),
                                isActive: $navigateToEdit
                            ) {
                                EmptyView()  // Hidden link
                            }
                            
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
        .navigationDestination(isPresented: $navigateToEdit) {
            if let user = viewModel.user {
                EditUserView(user: user, viewModel: viewModel)
            }
        }
    }
    
    private func deleteUser() {
        guard let userID = viewModel.user?.userID else { return }
        
        viewModel.deleteUser(userID: userID) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    UserSession.shared.logout() // Clear user session
                    presentationMode.wrappedValue.dismiss() // Navigate back to Login
                } else if let errorMessage = errorMessage {
                    print("Delete error: \(errorMessage)")
                }
            }
        }
    }
}
