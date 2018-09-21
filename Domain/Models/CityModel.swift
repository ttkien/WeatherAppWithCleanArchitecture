import Foundation

public struct CityModel : Codable {
    public let name: String
    public let country: String

    public init(name: String, country: String) {
        self.name = name
        self.country = country
    }
}
