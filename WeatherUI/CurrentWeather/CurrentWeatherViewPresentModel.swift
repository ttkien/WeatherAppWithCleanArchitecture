import Foundation

public struct CurrentWeatherViewPresentModel {
    public let location: String
    public let weather: String
    public let temperature: String

    public var daysOfWeek: String
    public var today: String
    public var minTem: String
    public var maxTem: String

    public init(location: String, weather: String, temperature: String, daysOfWeek: String, today: String, minTem: String, maxTem: String) {
        self.location = location
        self.weather = weather
        self.temperature = temperature
        self.daysOfWeek = daysOfWeek
        self.today = today
        self.minTem = minTem
        self.maxTem = maxTem
    }

}
