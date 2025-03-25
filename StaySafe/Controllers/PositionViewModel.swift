//
//  PositionViewModel.swift
//  StaySafe
//
//  Created by Heet Patel on 25/03/2025.
//

import Foundation
import Combine

class PositionViewModel: ObservableObject {
    @Published var positions: [Position] = []
    private var locationManager = LocationManager() // Using your existing LocationManager
    private var timer: Timer?
    
    var selectedActivityID: Int = 0
    var selectedActivityName: String = ""

    func startPostingPositions(activityID: Int, activityName: String) {
        self.selectedActivityID = activityID
        self.selectedActivityName = activityName
        
        timer?.invalidate() // Ensure no duplicate timers
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.postPosition()
        }
    }
    
    func stopPostingPositions() {
        timer?.invalidate()
        timer = nil
    }

    private func postPosition() {
        guard let currentLocation = locationManager.location else { return }
        
        let newPosition = Position(
            positionID: nil, // No ID when posting a new position
            positionActivityID: selectedActivityID,
            positionLatitude: currentLocation.latitude,
            positionLongitude: currentLocation.longitude,
            positionTimestamp: Int(Date().timeIntervalSince1970),
            positionActivityName: selectedActivityName
        )

        APIService.shared.postPosition(activityID: selectedActivityID, position: newPosition) { success in
            if success {
                DispatchQueue.main.async {
                    self.positions.append(newPosition)
                }
            }
        }
    }
}
