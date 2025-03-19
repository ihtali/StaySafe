//
//  ContactDetailsView.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 16/03/2025.
//
import SwiftUI
import MapKit

struct ContactDetailsView: View {
    let contact: Contact
    @StateObject private var activityViewModel = ActivityViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Contact Name Section
                Text("\(contact.userFirstName) \(contact.userLastName)")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)

                // Contact Details Section
                VStack(alignment: .leading, spacing: 16) {
                    DetailRow(title: "Phone", value: contact.userPhone)
                    DetailRow(title: "Label", value: contact.userContactLabel)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)

                // Activities Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Activities")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)

                    if activityViewModel.isLoading {
                        ProgressView("Loading activities...")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                            .padding()
                    } else if let errorMessage = activityViewModel.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.red)
                            .padding()
                    } else if activityViewModel.activities.isEmpty {
                        Text("No activities found.")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(activityViewModel.activities) { activity in
                            ActivityCard(activity: activity)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
            }
            .padding()
        }
        .navigationTitle("Contact Details")
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .onAppear {
            activityViewModel.fetchActivities(for: contact.userID)
        }
    }
}

// Activity Card View (Reusable Component)
struct ActivityCard: View {
    let activity: Activity

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Activity Name
            Text(activity.name)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)

            // Activity Details
            VStack(alignment: .leading, spacing: 12) {
                DetailRow(title: "Description", value: activity.description)
                DetailRow(title: "Leave Time", value: formatDate(activity.leaveTime))
                DetailRow(title: "Arrive Time", value: formatDate(activity.arriveTime))
                DetailRow(title: "Status", value: activity.statusName, isStatus: true)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
        }
    }

    // Function to format the date string
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm yyyy-MM-dd" // Time first, then date
            return outputFormatter.string(from: date)
        } else {
            return dateString // Return original string if parsing fails
        }
    }
}

// Custom View for Detail Rows
struct DetailRow: View {
    let title: String
    let value: String
    var isStatus: Bool = false

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.system(size: 16, weight: isStatus ? .semibold : .regular, design: .rounded))
                .foregroundColor(isStatus ? .blue : .primary)
        }
    }
}
