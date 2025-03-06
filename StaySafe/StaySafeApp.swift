//
//  StaySafeApp.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 20/02/2025.
//

import SwiftUI

@main
struct StaySafeApp: App {
    @StateObject private var userSession = UserSession()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(userSession)
        }
    }
}
