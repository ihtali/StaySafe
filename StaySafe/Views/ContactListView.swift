//
//  ContactListView.swift
//  StaySafe
//
//  Created by Heet Patel on 06/03/2025.
//
import SwiftUI

struct ContactListView: View {
    @EnvironmentObject var userSession: UserSession
    @StateObject private var contactViewModel = ContactViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if contactViewModel.isLoading {
                    ProgressView("Loading contacts...")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                        .padding()
                } else if let errorMessage = contactViewModel.errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.red)
                        .padding()
                } else if contactViewModel.contacts.isEmpty {
                    Text("No contacts found.")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(contactViewModel.contacts) { contact in
                            NavigationLink(destination: ContactDetailsView(contact: contact)) {
                                ContactRow(contact: contact)
                            }
                            .listRowBackground(Color(.systemBackground))
                        }
                    }
                    .listStyle(.plain)
                    .background(Color(.systemBackground))
                }
            }
            .navigationTitle("Contacts")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
            .onAppear {
                contactViewModel.fetchContacts(userID: userSession.userID)
            }
        }
    }
}

// Custom Contact Row View
struct ContactRow: View {
    let contact: Contact

    var body: some View {
        HStack(spacing: 16) {
            // Profile Image
            if let imageUrl = contact.userImage, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
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

            // Contact Details
            VStack(alignment: .leading, spacing: 6) {
                Text("\(contact.userFirstName) \(contact.userLastName)")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)

                Text(contact.userPhone)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)

                Text("Label: \(contact.userContactLabel)")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color(.systemBackground))
    }
}
