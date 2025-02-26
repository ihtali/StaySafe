//
//  UserView.swift
//  StaySafe
//
//  Created by Heet Patel on 26/02/2025.
//

import SwiftUI

struct UserView: View {
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        VStack {
            if let user = viewModel.user {
                Text("Name: \(user.firstName) \(user.lastName)")
                Text("Phone: \(user.phone)")
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            viewModel.fetchUser(userID: "12345")
        }
    }
}
