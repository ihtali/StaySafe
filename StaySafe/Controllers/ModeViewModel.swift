//
//  ModeViewModel.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 25/03/2025.
//

import Foundation
import Combine

// Define the Mode model
struct Mode: Identifiable {
    let modeID: Int
    let name: String

    var id: Int { modeID }
}

// ViewModel to handle fetching and managing modes
class ModeViewModel: ObservableObject {
    @Published var modes: [Mode] = []

    // Fetch available modes (simulate an API call here)
    func fetchModes() {
        // Simulate a network call to get the modes (replace with real network call if needed)
        self.modes = [
            Mode(modeID: 1, name: "Walking"),
            Mode(modeID: 2, name: "Cycling"),
            Mode(modeID: 3, name: "Driving"),
            Mode(modeID: 4, name: "Public Transport")
        ]
    }
    
    // Function to get mode name by ID (optional utility)
    func modeName(for id: Int) -> String? {
        return modes.first { $0.modeID == id }?.name
    }
}
