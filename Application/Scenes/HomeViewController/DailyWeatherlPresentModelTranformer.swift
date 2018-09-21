import Foundation
import Domain
import WeatherUI

protocol DailyWeatherlPresentModelTranformerProtocol {
    func tranform(dailyResult: DailyPredictionResult) -> DailyWeatherViewCellPresenter
}

class DailyWeatherlPresentModelTranformer : DailyWeatherlPresentModelTranformerProtocol {
    func tranform(dailyResult: DailyPredictionResult) -> DailyWeatherViewCellPresenter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: dailyResult.predictAtDay)
        let image = UIImage.image(from: dailyResult.weather?.type ?? .unknown)
        let minTemperature = TemperatureFormatter.sharedInstance.string(from: dailyResult.temperature?.minTemC)
        let maxTemperature = TemperatureFormatter.sharedInstance.string(from: dailyResult.temperature?.maxTemC)

        let model = DailyWeatherViewCellPresenter(day: day,
                                                  weather: image,
                                                  maxTemperature: minTemperature,
                                                  minTemperature: maxTemperature)
        return model
    }

}
