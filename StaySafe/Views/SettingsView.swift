//
//  SettingsView.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 05/03/2025.
//
import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled: Bool = true
    @State private var darkModeEnabled: Bool = false

    var body: some View {
        Form {
            Section(header: Text("Preferences")) {
                Toggle("Notifications", isOn: $notificationsEnabled)
                Toggle("Dark Mode", isOn: $darkModeEnabled)
            }

            Section {
                Button("Save") {
                    // Save action
                }
                Button("Logout") {
                    // Logout action
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Settings")
    }
}
