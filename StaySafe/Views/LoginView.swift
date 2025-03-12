//
//  Login.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 28/02/2025.
//
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var enteredUserID: String = ""

    var body: some View {
        VStack {
            Text("Welcome to StaySafe")
                .font(.largeTitle)
                .padding()

            TextField("Enter User ID", text: $enteredUserID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()

            Button("Login") {
                if !enteredUserID.isEmpty {
                    userSession.userID = enteredUserID
                    userSession.isLoggedIn = true
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(enteredUserID.isEmpty) // Disable button if no userID entered
        }
        .padding()
    }
}
