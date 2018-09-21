import Foundation

enum Vendor : String {
    case aerisWeather
    case forecastIO

    static let allValues: [Vendor] = [.aerisWeather, .forecastIO]
}
