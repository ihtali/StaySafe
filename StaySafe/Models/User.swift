import Foundation

struct User: Codable, Identifiable {
    var id: Int { userID }
    let userID: Int
    let firstName: String
    let lastName: String
    let phone: String
    let latitude: Double
    let longitude: Double
    let imageURL: String?
    let username: String
    let password: String
    let timestamp: Int  // Ensure this is provided when sending request

    enum CodingKeys: String, CodingKey {
        case userID = "UserID"
        case firstName = "UserFirstname"
        case lastName = "UserLastname"
        case phone = "UserPhone"
        case latitude = "UserLatitude"
        case longitude = "UserLongitude"
        case imageURL = "UserImageURL"
        case username = "UserUsername"
        case password = "UserPassword"
        case timestamp = "UserTimestamp"
    }
}
