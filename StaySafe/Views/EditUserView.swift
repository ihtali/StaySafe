//
//  EditUserView.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 19/03/2025.
//
//import SwiftUI
//
//struct EditUserView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @Binding var user: User  // Use @Binding instead of @State
//    @ObservedObject var viewModel: UserViewModel
//    @State private var firstName = ""
//    @State private var lastName = ""
//    @State private var phone = ""
//    @State private var isSaving = false
//
//    var body: some View {
//        Form {
//            Section(header: Text("Edit User Info")) {
//                TextField("First Name", text: $firstName)
//                TextField("Last Name", text: $lastName)
//                TextField("Phone", text: $phone)
//            }
//
//            Section {
//                Button(action: updateUser) {
//                    if isSaving {
//                        ProgressView()
//                    } else {
//                        Text("Save Changes")
//                    }
//                }
//                .disabled(isSaving)
//            }
//        }
//        .navigationTitle("Edit Profile")
//        .onAppear {
//            firstName = user.firstName
//            lastName = user.lastName
//            phone = user.phone
//        }
//    }
//
//    private func updateUser() {
//        isSaving = true
//        print("Updating user...") // Debug print
//
//        let updatedUser = User(
//            userID: user.userID,
//            firstName: firstName,
//            lastName: lastName,
//            phone: phone,
//            latitude: user.latitude,
//            longitude: user.longitude,
//            imageURL: user.imageURL,
//            username: user.username,
//            password: user.password,
//            timestamp: Int(Date().timeIntervalSince1970)
//        )
//
//        print("Updated user data: \(updatedUser)") // Debug print
//
//        viewModel.updateUser(userID: user.userID, updatedUser: updatedUser) { success, errorMessage in
//            DispatchQueue.main.async {
//                isSaving = false
//                if success {
//                    print("User successfully updated!") // Debug print
//                    user = updatedUser
//                    presentationMode.wrappedValue.dismiss()
//                } else {
//                    print("Update error: \(errorMessage ?? "Unknown error")") // Debug print
//                }
//            }
//        }
//    }
//
//
//}
