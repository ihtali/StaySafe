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
                } else if let errorMessage = contactViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if contactViewModel.contacts.isEmpty {
                    Text("No contacts found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(contactViewModel.contacts) { contact in
                        NavigationLink(destination: ActivityListView(userID: contact.userID)) {
                            HStack {
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

                                VStack(alignment: .leading) {
                                    Text("\(contact.userFirstName) \(contact.userLastName)")
                                        .font(.headline)
                                    Text(contact.userPhone)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text("Label: \(contact.userContactLabel)")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Contacts")
            .onAppear {
                contactViewModel.fetchContacts(userID: userSession.userID)
            }
        }
    }
}

#Preview {
    ContactListView()
}
