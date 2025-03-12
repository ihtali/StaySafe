//
//  HomeView.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 28/02/2025.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ActivityViewModel()
    @EnvironmentObject var userSession: UserSession

    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Text("StaySafe")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    NavigationLink(destination: UserView()) {
                        Image(systemName: "person.circle").font(.system(size: 30))
                    }
                }
                .padding()

                // Activity List with Swipe Actions
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
                    List {
                        ForEach(viewModel.activities) { activity in
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
                            .swipeActions(edge: .trailing) {
                                // Modify Button
                                Button {
                                    navigateToModifyActivity(activity: activity)
                                } label: {
                                    Label("Modify", systemImage: "pencil")
                                }
                                .tint(.blue)

                                // Delete Button
                                Button(role: .destructive) {
                                    deleteActivity(activityID: activity.activityID)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding(.top)
                }

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
            }
            .navigationBarHidden(true)
            .onAppear {
                if let userID = Int(userSession.userID) {
                    viewModel.fetchActivities(for: userID)
                }
            }
        }
    }

    // Navigate to Modify Activity
    private func navigateToModifyActivity(activity: Activity) {
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            let modifyView = UIHostingController(rootView: ActivityModifyView(activity: activity))
            rootViewController.present(modifyView, animated: true, completion: nil)
        }
    }

    // Delete Activity
    private func deleteActivity(activityID: Int) {
        viewModel.deleteActivity(activityID: activityID) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    viewModel.activities.removeAll { $0.activityID == activityID }
                } else if let errorMessage = errorMessage {
                    print("Error: \(errorMessage)")
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
