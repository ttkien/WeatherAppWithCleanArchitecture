import Foundation
import Domain
import WeatherUI

protocol CurrentWeatherPresentModelTranformerProtocol {
    func tranform(locationFilters: LocationFilters, predictionResult: PredictionResult) -> CurrentWeatherViewPresentModel
}

class CurrentWeatherPresentModelTranformer : CurrentWeatherPresentModelTranformerProtocol {
    func tranform(locationFilters: LocationFilters, predictionResult: PredictionResult) -> CurrentWeatherViewPresentModel {
        let location = locationName(filterLocations: locationFilters).capitalized
        let temperature = TemperatureFormatter.sharedInstance.string(from: predictionResult.temperature?.temC)
        let minTemperature = TemperatureFormatter.sharedInstance.string(from: predictionResult.temperature?.minTemC)
        let maxTemperature = TemperatureFormatter.sharedInstance.string(from: predictionResult.temperature?.maxTemC)
        let weather = Constants.title(from: predictionResult.cloudiness?.type ?? .unknown).capitalized
        let daysOfWeek = DayOfWeekFormatter.sharedInstance.string(from: Date())
        let model = CurrentWeatherViewPresentModel(location: location,
                                                   weather: weather,
                                                   temperature: temperature,
                                                   daysOfWeek: daysOfWeek,
                                                   today: "Today",
                                                   minTem: "Low: " + minTemperature,
                                                   maxTem: "High: " + maxTemperature
        )
        return model
    }

    func locationName(filterLocations: LocationFilters) -> String {
        if let cityModel = filterLocations.city {
            return [cityModel.name].joined(separator: ",")
        } else if let location = filterLocations.location {
            return "\(location.latitude), \(location.longitude)"
        } else {
            return ""
        }
    }

}
