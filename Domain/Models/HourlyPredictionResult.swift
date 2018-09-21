import Foundation

public struct HourlyPredictionResult {
    public let predictAtHour: Date
    public let wind: WindModel?
    public let humidity: HumidityModel?
    public let cloudiness: CloudinessModel?
    public let temperature: TemperaturModel?
    public let weather: WeatherModel?

    public init(predictAtHour: Date,
                wind: WindModel?,
                humidity: HumidityModel?,
                cloudiness: CloudinessModel?,
                temperature:TemperaturModel?,
                weather: WeatherModel?) {
        self.wind = wind
        self.humidity = humidity
        self.cloudiness = cloudiness
        self.predictAtHour = predictAtHour
        self.temperature = temperature
        self.weather = weather
    }
}
