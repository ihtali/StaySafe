//
//  HomeView.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 28/02/2025.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Text("StaySafe")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: "person.circle")
                        .font(.system(size: 30))
                }
                .padding()

                // Activity List
                List {
                    ActivityRow(activityName: "Walking to Park", status: "Started", time: "10:00 AM, Today")
                    ActivityRow(activityName: "Jogging", status: "Completed", time: "8:00 AM, Yesterday")
                }
                .listStyle(PlainListStyle())

                // Quick Actions
                VStack(spacing: 20) {
                    NavigationLink(destination: ActivityCreationView()) {
                        Text("Create New Activity")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        // Panic button action
                    }) {
                        Text("Panic Button")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: MapView()) {
                        Text("View Map")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()

                // Bottom Navigation Bar
                Spacer()
                HStack {
                    NavigationLink(destination: HomeView()) {
                        VStack {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    }
                    Spacer()
                    NavigationLink(destination: ContactsView()) {
                        VStack {
                            Image(systemName: "person.2.fill")
                            Text("Contacts")
                        }
                    }
                    Spacer()
                    NavigationLink(destination: MapView()) {
                        VStack {
                            Image(systemName: "map.fill")
                            Text("Map")
                        }
                    }
                    Spacer()
                    NavigationLink(destination: SettingsView()) {
                        VStack {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
            }
            .navigationBarHidden(true)
        }
    }
}

struct ActivityRow: View {
    var activityName: String
    var status: String
    var time: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(activityName)
                .font(.headline)
            Text(status)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(time)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}
