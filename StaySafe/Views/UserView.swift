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

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading user data...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if let user = viewModel.user {
                VStack {
                    Text("Name: \(user.firstName) \(user.lastName)")
                    Text("Phone: \(user.phone)")
                }
                .padding()
            } else {
                Text("User not found")
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            viewModel.fetchUser(userID: userSession.userID)
        }
    }
}

