//
//  ActivityListView.swift
//  StaySafe
//
//  Created by Heet Patel on 06/03/2025.
//

import SwiftUI

struct ActivityListView: View {
    @StateObject private var viewModel = ActivityViewModel()
    let userID: Int  // Passed from ContactListView

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading activities...")
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
                }
            }
        }
        .navigationTitle("Activities")
        .onAppear {
            viewModel.fetchActivities(for: userID)
        }
    }
}

