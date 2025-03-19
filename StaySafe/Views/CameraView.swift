//
//  CameraView.swift
//  StaySafe
//
//  Created by Heet Patel on 19/03/2025.
//

import SwiftUI

struct CameraView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var cameraController = CameraController()
    
    var onCapture: (URL) -> Void
    
    var body: some View {
        ZStack {
            CameraPreview(cameraController: cameraController)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Button(action: {
                    cameraController.capturePhoto()
                }) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 70, height: 70)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            cameraController.startSession()
        }
        .onDisappear {
            cameraController.stopSession()
        }
        .onChange(of: cameraController.capturedImageURL) { newURL in
                    if let newURL = newURL {
                        onCapture(newURL)
                        dismiss()
            }
        }
    }
}

#Preview {
    //CameraView()
}
