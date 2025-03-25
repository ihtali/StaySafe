//
//  ModeService.swift
//  StaySafe
//
//  Created by Ihtasham Ali on 25/03/2025.
//
import Foundation

class ModeService {
    static let shared = ModeService()
    private let apiURL = "https://softwarehub.uk/unibase/staysafe/v2/api/modes"
    
    private init() {}

    func fetchModes(completion: @escaping ([TravelMode]?) -> Void) {
        guard let url = URL(string: apiURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching modes: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let modes = try JSONDecoder().decode([TravelMode].self, from: data)
                completion(modes)
            } catch {
                print("JSON Parsing Error: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}
