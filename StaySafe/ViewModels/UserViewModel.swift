//
//  UserViewModel.swift
//  StaySafe
//
//  Created by Heet Patel on 26/02/2025.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var user: User?

    func fetchUser(userID: String) {
        MockAPIManager.shared.getUser(userID: userID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userData):
                    self.objectWillChange.send()
                    self.user = userData
                    print("Fetched user:\(userData)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}

