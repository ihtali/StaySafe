//
//  ContentView.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 20/02/2025.
//

import SwiftUI

struct ContentView: View {
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
        .padding()
        .onAppear {
            print("ContentView appeared!") 
            viewModel.fetchUser(userID: "12345")
        }
    }
}

#Preview {
    ContentView()
}
