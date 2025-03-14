//
//  ContactListView.swift
//  StaySafe
//
//  Created by Heet Patel on 06/03/2025.
//
import SwiftUI

struct ContactListView: View {
    @StateObject private var contactViewModel = ContactViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header (Matching ActivityDetailsView Style)
                VStack {
                    HStack {
                        Text("Contacts")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .edgesIgnoringSafeArea(.top)

                // Contacts List
                ScrollView {
                    VStack(spacing: 16) {
                        // Loading, Error, or Empty State
                        if contactViewModel.isLoading {
                            ProgressView("Loading contacts...")
                                .padding()
                        } else if let errorMessage = contactViewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        } else if contactViewModel.contacts.isEmpty {
                            Text("No contacts found.")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            // List of Contacts
                            ForEach(contactViewModel.contacts) { contact in
                                NavigationLink(destination: ActivityListView(userID: contact.userID)) {
                                    HStack(spacing: 16) {
                                        // User Image
                                        if let imageUrl = contact.userImage, let url = URL(string: imageUrl) {
                                            AsyncImage(url: url) { image in
                                                image.resizable()
                                                    .scaledToFill()
                                                    .frame(width: 50, height: 50)
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                            } placeholder: {
                                                Image(systemName: "person.circle.fill")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 50, height: 50)
                                                    .foregroundColor(.gray)
                                            }
                                        } else {
                                            Image(systemName: "person.circle.fill")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.gray)
                                        }

                                        // Contact Info
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("\(contact.userFirstName) \(contact.userLastName)")
                                                .font(.headline)
                                                .foregroundColor(.primary)

                                            Text(contact.userPhone)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)

                                            Text("Label: \(contact.userContactLabel)")
                                                .font(.caption)
                                                .foregroundColor(.blue)
                                        }
                                        .padding(.vertical, 10)

                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                }
                                .buttonStyle(PlainButtonStyle()) // Remove default button styling
                            }
                        }
                    }
                    .padding()
                }
                .background(Color(.systemBackground)) // Use system background for light/dark mode support
            }
            .navigationBarHidden(true) // Hide default navigation bar
            .onAppear {
                contactViewModel.fetchContacts()
            }
        }
    }
}

#Preview {
    ContactListView()
}
