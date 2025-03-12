//
//  HomeView.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 28/02/2025.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ActivityViewModel()
    let userID: Int = 1  // Example user ID, replace with actual user ID if needed
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Text("StaySafe")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    NavigationLink(destination: UserView()) { // Navigate to UserView
                    Image(systemName: "person.circle").font(.system(size: 30))
                    }
                }
                .padding()

                // Activity List (directly shown in HomeView)
                if viewModel.isLoading {
                    ProgressView("Loading activities...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.activities.isEmpty {
                    Text("No activities found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.activities) { activity in
                        NavigationLink(destination: ActivityDetailsView(activity: activity)) {
                            VStack(alignment: .leading) {
                                Text(activity.name)
                                    .font(.headline)
                                Text(activity.description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Status: \(activity.statusName)")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.top)
                }

                // Quick Actions
                VStack(spacing: 20) {
                    NavigationLink(destination: ActivityCreationView(userID: userID)) {
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
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.fetchActivities(for: userID)
            }
        }
    }
}

#Preview {
    HomeView()
}

