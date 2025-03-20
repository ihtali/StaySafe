//
//  CameraPreview.swift
//  StaySafe
//
//  Created by Heet Patel on 19/03/2025.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var cameraController: CameraController
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        cameraController.previewLayer.videoGravity = .resizeAspectFill
        cameraController.previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(cameraController.previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
