//
//  MotionManager.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 25/03/2025.
//
import CoreMotion

class MotionManager {
    static let shared = MotionManager()
    
    private let motionActivityManager = CMMotionActivityManager()
    private let motionManager = CMMotionManager()
    private var travelModes: [TravelMode] = []

    private init() {
        fetchTravelModes()
    }
    
    // Fetch travel modes from API
    private func fetchTravelModes() {
        ModeService.shared.fetchModes { [weak self] modes in
            guard let self = self, let modes = modes else { return }
            self.travelModes = modes
            print("Fetched Travel Modes: \(modes.map { $0.ModeName })")
        }
    }

    // Detect user activity
    func startMotionDetection() {
        if CMMotionActivityManager.isActivityAvailable() {
            motionActivityManager.startActivityUpdates(to: OperationQueue.main) { [weak self] activity in
                guard let self = self, let activity = activity else { return }
                
                let detectedMode = self.mapActivityToMode(activity)
                print("Detected Mode: \(detectedMode)")
            }
        }
    }

    // Map sensor data to API mode
    private func mapActivityToMode(_ activity: CMMotionActivity) -> String {
        if activity.walking { return findModeByName("Walk") }
        if activity.running { return findModeByName("Run") }
        if activity.cycling { return findModeByName("Bicycle") }
        if activity.automotive { return findModeByName("Car") }
        return "Unknown"
    }

    // Find mode name dynamically from API data
    private func findModeByName(_ name: String) -> String {
        return travelModes.first { $0.ModeName.lowercased() == name.lowercased() }?.ModeName ?? "Unknown"
    }
}

