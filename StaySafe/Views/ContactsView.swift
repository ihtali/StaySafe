//
//  ContactsView.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 05/03/2025.
//
import  SwiftUI

struct ContactsView: View {
    var body: some View {
        VStack {
            List {
                ContactRow(name: "John Doe", phone: "123-456-7890", relationship: "Partner")
                ContactRow(name: "Jane Smith", phone: "987-654-3210", relationship: "Friend")
            }
            .listStyle(PlainListStyle())

            Button("Add Contact") {
                // Add contact action
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
        .navigationTitle("Contacts")
    }
}

struct ContactRow: View {
    var name: String
    var phone: String
    var relationship: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.headline)
            Text(phone)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(relationship)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}
