//
//  ActivityTestView.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 25/03/2025.
//
import SwiftUI

struct ActivityTestView: View {
    @StateObject private var activityDetectionManager = ActivityDetectionManager()
    @State private var isDetecting: Bool = true

    var body: some View {
        VStack {
            Text("Activity Detection Test")
                .font(.largeTitle)
                .bold()
                .padding()

            Text("Current Activity: \(activityDetectionManager.detectedActivity)")
                .font(.title)
                .padding()
                .foregroundColor(.blue)

            Button(action: toggleActivityDetection) {
                HStack {
                    if isDetecting {
                        ProgressView()
                    }
                    Text(isDetecting ? "Stop Detection" : "Start Detection")
                        .font(.headline)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(isDetecting ? Color.red : Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
            }
        }
        .onDisappear {
            activityDetectionManager.stopActivityDetection()
        }
    }

    private func toggleActivityDetection() {
        if isDetecting {
            activityDetectionManager.stopActivityDetection()
        } else {
            activityDetectionManager.startActivityDetection()
        }
        isDetecting.toggle()
    }
}
