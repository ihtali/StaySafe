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
    @State private var showLogoutConfirmation: Bool = false
    @EnvironmentObject var userSession: UserSession // Access the shared UserSession instance

    var body: some View {
        NavigationView {
            Form {
                // Preferences Section
                Section(header: Text("Preferences")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { newValue in
                            savePreferences()
                        }

                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                        .onChange(of: darkModeEnabled) { newValue in
                            savePreferences()
                            updateAppearance(newValue)
                        }
                }

                // Actions Section
                Section {
                    Button("Save Preferences") {
                        savePreferences()
                    }

                    Button("Logout") {
                        showLogoutConfirmation = true
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .alert(isPresented: $showLogoutConfirmation) {
                Alert(
                    title: Text("Logout"),
                    message: Text("Are you sure you want to logout?"),
                    primaryButton: .destructive(Text("Logout")) {
                        logout()
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                loadPreferences()
            }
        }
    }

    // MARK: - Helper Functions

    // Save preferences to UserDefaults
    private func savePreferences() {
        UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        UserDefaults.standard.set(darkModeEnabled, forKey: "darkModeEnabled")
    }

    // Load preferences from UserDefaults
    private func loadPreferences() {
        notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
    }

    // Update app appearance based on dark mode preference
    private func updateAppearance(_ isDarkMode: Bool) {
        if isDarkMode {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        } else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        }
    }

    // Logout the user
    private func logout() {
        userSession.isLoggedIn = false
        // Clear any additional user data if needed
    }
}
