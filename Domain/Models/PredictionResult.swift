import Foundation

public struct PredictionResult {
    public let wind: WindModel?
    public let humidity: HumidityModel?
    public let cloudiness: CloudinessModel?
    public let temperature: TemperaturModel?
    public let weather: WeatherModel?
    public let sunrise: Date?
    public let sunset: Date?
    public let feelLike: Float?
    public let precipatation: Float?
    public let pressure: Float?
    public let visibility: Float?
    public let uvIndex: Float?

    public init(wind: WindModel?,
                humidity: HumidityModel?,
                cloudiness: CloudinessModel?,
                temperature: TemperaturModel?,
                weather: WeatherModel?,
                sunrise: Date?,
                sunset: Date?,
                feelLike: Float?,
                precipatation: Float?,
                pressure: Float?,
                visibility: Float?,
                uvIndex: Float?) {
        self.wind = wind
        self.humidity = humidity
        self.cloudiness = cloudiness
        self.temperature = temperature
        self.weather = weather
        self.sunrise = sunrise
        self.sunset = sunset
        self.feelLike = feelLike
        self.precipatation = precipatation
        self.pressure = pressure
        self.visibility = visibility
        self.uvIndex = uvIndex
    }
}
