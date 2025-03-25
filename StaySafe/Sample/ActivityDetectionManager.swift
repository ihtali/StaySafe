//
//  ActivityDetectionManager.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 25/03/2025.
import SwiftUI
import CoreMotion

class ActivityDetectionManager: ObservableObject {
    private let motionActivityManager = CMMotionActivityManager()
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()

    @Published var detectedActivity: String = "Unknown"

    func startActivityDetection() {
        print("[ActivityDetection] Starting detection...")

        // Motion Activity Manager (Walking, Running, Cycling, Vehicle)
        if CMMotionActivityManager.isActivityAvailable() {
            motionActivityManager.startActivityUpdates(to: queue) { [weak self] activity in
                DispatchQueue.main.async {
                    if let activity = activity {
                        if activity.walking {
                            self?.updateActivity("Walking", source: "MotionActivityManager")
                        } else if activity.running {
                            self?.updateActivity("Running", source: "MotionActivityManager")
                        } else if activity.cycling {
                            self?.updateActivity("Cycling", source: "MotionActivityManager")
                        } else if activity.automotive {
                            self?.updateActivity("In Vehicle", source: "MotionActivityManager")
                        } else if activity.stationary {
                            self?.updateActivity("Stationary", source: "MotionActivityManager")
                        } else {
                            self?.updateActivity("Unknown", source: "MotionActivityManager")
                        }
                    }
                }
            }
        }

        // Accelerometer for real-time movement
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: queue) { [weak self] data, _ in
                if let acceleration = data?.acceleration {
                    let totalAcceleration = sqrt(acceleration.x * acceleration.x +
                                                 acceleration.y * acceleration.y +
                                                 acceleration.z * acceleration.z)

                    DispatchQueue.main.async {
                        if totalAcceleration > 4.5 {
                            self?.updateActivity("In Vehicle (Accelerometer)", source: "Accelerometer")
                        } else if totalAcceleration > 2.0 {
                            self?.updateActivity("Running (Accelerometer)", source: "Accelerometer")
                        } else if totalAcceleration > 2.8 {
                            self?.updateActivity("Cycling (Accelerometer)", source: "Accelerometer")
                        } else if totalAcceleration > 1.0 {
                            self?.updateActivity("Walking (Accelerometer)", source: "Accelerometer")
                        }
                    }
                }
            }
        }
    }

    func stopActivityDetection() {
        print("[ActivityDetection] Stopping detection...")
        motionActivityManager.stopActivityUpdates()
        motionManager.stopAccelerometerUpdates()
    }

    private func updateActivity(_ activity: String, source: String) {
        detectedActivity = activity
        print("[\(source)] Detected: \(activity)")
    }
}
