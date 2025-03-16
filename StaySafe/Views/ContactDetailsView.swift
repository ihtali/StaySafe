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
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    .shadow(radius: 5)

                // Contact Details Section
                VStack(alignment: .leading, spacing: 15) {
                    DetailRow(title: "Phone", value: contact.userPhone)
                    DetailRow(title: "Label", value: contact.userContactLabel)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)

                // Activities Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Activities")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.top, 10)

                    if activityViewModel.isLoading {
                        ProgressView("Loading activities...")
                            .padding()
                    } else if let errorMessage = activityViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else if activityViewModel.activities.isEmpty {
                        Text("No activities found.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(activityViewModel.activities) { activity in
                            ActivityCard(activity: activity)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .padding()
        }
        .navigationTitle("Contact Details")
        .onAppear {
            activityViewModel.fetchActivities(for: contact.userID)
        }
    }
}

// Activity Card View (Reusable Component)
struct ActivityCard: View {
    let activity: Activity

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Activity Name
            Text(activity.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(10)
                .shadow(radius: 5)

            // Activity Details
            VStack(alignment: .leading, spacing: 10) {
                DetailRow(title: "Description", value: activity.description)
                DetailRow(title: "Leave Time", value: formatDate(activity.leaveTime))
                DetailRow(title: "Arrive Time", value: formatDate(activity.arriveTime))
                DetailRow(title: "Status", value: activity.statusName, isStatus: true)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
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
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundColor(isStatus ? .blue : .black)
                .fontWeight(isStatus ? .bold : .regular)
        }
    }
}
