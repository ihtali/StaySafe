import Foundation

struct User: Codable, Identifiable, Equatable {
    var id: Int { userID }
    let userID: Int
    var firstName: String
    var lastName: String
    var phone: String
    let latitude: Double
    let longitude: Double
    let imageURL: String?
    let username: String
    var password: String? // Make this mutable
    let timestamp: Int

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
