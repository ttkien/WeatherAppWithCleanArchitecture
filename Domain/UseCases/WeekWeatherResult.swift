import Foundation

public struct WeekWeatherResult {
    public let dailyPredictionItem: [DailyPredictionResult]

    public init(dailyPredictionItem: [DailyPredictionResult]) {
        self.dailyPredictionItem = dailyPredictionItem
    }
}
