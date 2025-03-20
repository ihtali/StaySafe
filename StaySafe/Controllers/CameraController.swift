//
//  Camera.swift
//  StaySafe
//
//  Created by Heet Patel on 19/03/2025.
//
import AVFoundation
import SwiftUI
import UIKit

class CameraController: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    // MARK: - Private Properties
    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let cameraQueue = DispatchQueue(label: "cameraQueue")
    
    // MARK: - Published Properties
    // Publishes the file URL of the saved image
    @Published var capturedImageURL: URL?
    
    // Exposes the preview layer for live camera feed
    @Published var previewLayer: AVCaptureVideoPreviewLayer
    
    // MARK: - Initialization
    override init() {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        super.init()
        configureSession()
    }
    
    // MARK: - Session Configuration
    private func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            session.commitConfiguration()
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
        
        session.commitConfiguration()
    }
    
    // MARK: - Session Management
    func startSession() {
        cameraQueue.async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    
    func stopSession() {
        cameraQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    // MARK: - Photo Capture
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    // MARK: - Photo Capture Delegate
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil,
              let imageData = photo.fileDataRepresentation() else {
            print("Error capturing photo: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        
        // Save the image to disk and update the published URL
        if let savedURL = saveImageToDisk(imageData: imageData) {
            DispatchQueue.main.async {
                self.capturedImageURL = savedURL
            }
        }
    }
    
    // MARK: - Image Persistence
    private func saveImageToDisk(imageData: Data) -> URL? {
        let fileManager = FileManager.default
        
        // Locate the documents directory for the app
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        // Create a unique file name using a UUID
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: fileURL)
            return fileURL
        } catch {
            print("Failed to save image to disk: \(error)")
            return nil
        }
    }
}


