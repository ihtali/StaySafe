//
//  LocationManager.swift
//  StaySafe
//
//  Created by Heet Patel on 19/03/2025.
//
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    @Published var locationString: String = "Fetching location..."
    @Published var detectedMode: String = "Unknown"

    private var travelModes: [TravelMode] = []

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        fetchTravelModes()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            self.location = lastLocation.coordinate
            reverseGeocode(location: lastLocation)
            detectTravelMode(speed: lastLocation.speed)  // Speed-based detection
        }
    }

    private func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                self.locationString = [
                    placemark.name,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.country
                ].compactMap { $0 }.joined(separator: ", ")
            } else {
                self.locationString = "Lat: \(location.coordinate.latitude), Lon: \(location.coordinate.longitude)"
            }
        }
    }

    // Fetch travel modes dynamically from API
    private func fetchTravelModes() {
        ModeService.shared.fetchModes { [weak self] modes in
            guard let self = self, let modes = modes else { return }
            self.travelModes = modes
        }
    }

    // Detect travel mode based on speed
    private func detectTravelMode(speed: Double) {
        if speed > 0 && speed < 2 { detectedMode = findModeByName("Walk") }
        else if speed >= 2 && speed < 5 { detectedMode = findModeByName("Run") }
        else if speed >= 5 && speed < 15 { detectedMode = findModeByName("Bicycle") }
        else if speed >= 15 { detectedMode = findModeByName("Car") }
        else { detectedMode = "Unknown" }

        print("Detected Mode: \(detectedMode)")
    }

    private func findModeByName(_ name: String) -> String {
        return travelModes.first { $0.ModeName.lowercased() == name.lowercased() }?.ModeName ?? "Unknown"
    }
}
