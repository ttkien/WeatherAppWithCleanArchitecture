import Foundation

public struct TodayWeatherResult {
    public let hourlyPredictionItem: [HourlyPredictionResult]

    public init(hourlyPredictionItem: [HourlyPredictionResult]) {
        self.hourlyPredictionItem = hourlyPredictionItem
    }

}
