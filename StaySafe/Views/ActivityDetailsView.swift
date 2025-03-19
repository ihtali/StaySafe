import SwiftUI
import MapKit

struct ActivityDetailsView: View {
    let activity: Activity
    @StateObject private var locationViewModel = LocationViewModel()
    @State private var region: MKCoordinateRegion?
    @State private var showCamera = false
    @State private var activityImageURL: URL?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Activity Name Section
                Text(activity.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    .shadow(radius: 5)

                // Activity Details Section
                VStack(alignment: .leading, spacing: 15) {
                    DetailRow(title: "Description", value: activity.description)
                    DetailRow(title: "Leave Time", value: formatDate(activity.leaveTime))
                    DetailRow(title: "Arrive Time", value: formatDate(activity.arriveTime))
                    DetailRow(title: "Status", value: activity.statusName, isStatus: true)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)

                // Image Preview Section
                if let imageURL = activityImageURL {
                    VStack {
                        Text("Activity Image")
                            .font(.headline)
                        Image(uiImage: loadImage(from: imageURL))
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding()
                }

                // Capture Image Button
                Button(action: {
                    showCamera = true
                }) {
                    Text(activityImageURL == nil ? "Capture Image" : "Retake Image")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()

                // Map Section
                if let fromLocation = locationViewModel.locations.first(where: { $0.locationID == activity.fromLocationID }),
                   let toLocation = locationViewModel.locations.first(where: { $0.locationID == activity.toLocationID }) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("From & To Locations")
                            .font(.headline)
                            .foregroundColor(.black)

                        Map(
                            coordinateRegion: Binding(
                                get: { region ?? MKCoordinateRegion(
                                    center: CLLocationCoordinate2D(
                                        latitude: (fromLocation.latitude + toLocation.latitude) / 2,
                                        longitude: (fromLocation.longitude + toLocation.longitude) / 2
                                    ),
                                    span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                                ) },
                                set: { region = $0 }
                            ),
                            annotationItems: [fromLocation, toLocation]
                        ) { location in
                            MapMarker(
                                coordinate: CLLocationCoordinate2D(
                                    latitude: location.latitude,
                                    longitude: location.longitude
                                ),
                                tint: location.locationID == activity.fromLocationID ? .green : .blue
                            )
                        }
                        .frame(height: 300)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                } else {
                    Text("Loading locations...")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle("Activity Details")
        .onAppear {
            locationViewModel.fetchLocations()
            loadImageForActivity()
        }
        .sheet(isPresented: $showCamera) {
            CameraView { capturedURL in
                saveImageForActivity(imageURL: capturedURL)
            }
        }
    }

    // Function to format the date string (time first, then date)
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

    // Load image from saved URL
    private func loadImage(from url: URL) -> UIImage {
        guard let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return UIImage(systemName: "photo")! // Default placeholder
        }
        return image
    }

    // Load stored image for the activity
    private func loadImageForActivity() {
        if let savedURL = UserDefaults.standard.string(forKey: "activityImage_\(activity.activityID)"),
           let url = URL(string: savedURL) {
            activityImageURL = url
        }
    }

    // Save captured image URL
    private func saveImageForActivity(imageURL: URL) {
        activityImageURL = imageURL
        UserDefaults.standard.setValue(imageURL.absoluteString, forKey: "activityImage_\(activity.activityID)")
    }
}
