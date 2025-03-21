import SwiftUI
import MessageUI

struct HomeView: View {
    @StateObject private var viewModel = ActivityViewModel()
    @EnvironmentObject var userSession: UserSession
    @StateObject private var locationManager = LocationManager()
    @State private var showMessageComposer = false
    @State private var messageError: ErrorMessage?

    let emergencyContacts = ["+447923629056", "+447747260083"]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Activity List with Swipe Actions
                if viewModel.isLoading {
                    ProgressView("Loading activities...")
                        .padding()
                        .foregroundColor(.gray)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.activities.isEmpty {
                    VStack {
                        Image(systemName: "tray.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray.opacity(0.5))
                        Text("No activities found.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.activities) { activity in
                            NavigationLink(destination: ActivityDetailsView(activity: activity)) {
                                ActivityRow(activity: activity)
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    navigateToModifyActivity(activity: activity)
                                } label: {
                                    Label("Modify", systemImage: "pencil")
                                }
                                .tint(.blue)
                                
                                Button(role: .destructive) {
                                    deleteActivity(activityID: activity.activityID)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }

                // Quick Actions
                VStack(spacing: 20) {
                    NavigationLink(destination: ActivityCreationView()) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 22))
                            Text("Create New Activity")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .blue.opacity(0.4), radius: 8, x: 0, y: 4)
                    }

                    Button(action: {
                        sendPanicMessage()
                    }) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 22))
                            Text("Panic Button")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.red.opacity(1), Color.orange.opacity(0.8)]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .red.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .navigationTitle("My Activities")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("StaySafe")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: UserView()) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.gray)
                    }
                }
            }
            .onAppear {
                if let userID = Int(userSession.userID) {
                    viewModel.fetchActivities(for: userID)
                }
            }
            .sheet(isPresented: $showMessageComposer) {
                MessageComposer(recipients: emergencyContacts, body: "Emergency! I need help. My location: \(locationManager.locationString)")
            }
            .alert(item: $messageError) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
        }
    }

    func sendPanicMessage() {
        if MFMessageComposeViewController.canSendText() {
            showMessageComposer = true
        } else {
            messageError = ErrorMessage(message: "Your device doesn't support text messaging.")
        }
    }
    
    private func navigateToModifyActivity(activity: Activity) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            let modifyView = UIHostingController(rootView: ActivityModifyView(activity: activity))
            rootViewController.present(modifyView, animated: true, completion: nil)
        }
    }
    
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

struct ActivityRow: View {
    let activity: Activity

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(activity.name)
                .font(.headline)
                .foregroundColor(.primary)
            Text(activity.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Status: \(activity.statusName)")
                .font(.caption)
                .foregroundColor(.blue)
        }
    }
}
