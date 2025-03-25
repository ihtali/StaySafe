//
//  StaySafeApp.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 20/02/2025.
//

import SwiftUI

@main
struct StaySafeApp: App {
    @StateObject private var userSession = UserSession() // Single instance for the app

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userSession) // Provide session to entire app
        }
    }
}


