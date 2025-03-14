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
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "person.circle")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .shadow(radius: 10)

                // "My Activities" Title
                Text("My Activities")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding([.top, .leading])
                    .foregroundColor(.black)

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
                                    .foregroundColor(.black)
                                Text(activity.description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Status: \(activity.statusName)")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                        .padding(.vertical, 5)
                    }
                    .listStyle(PlainListStyle())
                }

                // Quick Actions
                VStack(spacing: 20) {
                    NavigationLink(destination: ActivityCreationView()) {
                        Text("Create New Activity")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
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
                            .shadow(radius: 5)
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
