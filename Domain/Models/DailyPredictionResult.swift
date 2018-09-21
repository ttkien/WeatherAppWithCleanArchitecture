import Foundation

public struct DailyPredictionResult {
    public let predictAtDay: Date

    public let wind: WindModel?
    public let humidity: HumidityModel?
    public let cloudiness: CloudinessModel?
    public let temperature: TemperaturModel?
    public let weather: WeatherModel?

    public init(wind: WindModel?,
                humidity: HumidityModel?,
                cloudiness: CloudinessModel?,
                temperature: TemperaturModel?,
                weather: WeatherModel?,
                predictAtDay: Date) {
        self.wind = wind
        self.humidity = humidity
        self.cloudiness = cloudiness
        self.temperature = temperature
        self.weather = weather
        self.predictAtDay = predictAtDay
    }

}
