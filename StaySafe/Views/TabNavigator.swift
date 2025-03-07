//
//  TabNavigator.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 07/03/2025.
//
import SwiftUI

struct TabNavigator: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            ContactListView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Contacts")
                }

            MapView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    TabNavigator()
}
