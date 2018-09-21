import Foundation

public struct DailyWeatherViewCellPresenter {
    
    public let day: String
    public let weather: UIImage
    public let maxTemperature: String
    public let minTemperature: String

    public init(day: String,
                weather: UIImage,
                maxTemperature: String,
                minTemperature: String) {
        self.day = day
        self.weather = weather
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
    }
}
