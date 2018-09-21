import Foundation
import Domain
import WeatherUI

protocol CurrentWeatherDetailPresentModelTranformerProtocol {
    func tranform(predictionResult: PredictionResult) -> WeatherDetailViewPresentModel
}

class CurrentWeatherDetailPresentModelTranformer : CurrentWeatherDetailPresentModelTranformerProtocol {
    func tranform(predictionResult: PredictionResult) -> WeatherDetailViewPresentModel {
        let chanceOfRain = ChanceOfRainFormatter.sharedInstance.string(from: predictionResult.weather?.chanceOfRain)
        let humidity = HumidityFormatter.sharedInstance.string(from: predictionResult.humidity)
        let wind = WindFormatter.sharedInstance.string(from: predictionResult.wind)
        let cloudiness = CloudinessFormatter.sharedInstance.string(from: predictionResult.cloudiness)
        let sunrise = SunriseFormatter.sharedInstance.string(from: predictionResult.sunrise)
        let sunset = SunsetFormatter.sharedInstance.string(from: predictionResult.sunset)
        let feelLike = FeelLikesFormatter.sharedInstance.string(from: predictionResult.feelLike)
        let precipatation = PrecipatationFormatter.sharedInstance
            .string(from: predictionResult.precipatation)
        let pressure = PressureFormatter.sharedInstance.string(from: predictionResult.pressure)
        let visibility = VisibilityFormatter.sharedInstance.string(from: predictionResult.visibility)

        let uvIndex = UVIndexFormatter.sharedInstance.string(from: predictionResult.uvIndex)
        let model = WeatherDetailViewPresentModel(chanceOfRain: chanceOfRain,
                                                  humidity: humidity,
                                                  wind: wind,
                                                  cloudiness: cloudiness,
                                                  sunrise: sunrise,
                                                  sunset: sunset,
                                                  feelLike: feelLike,
                                                  precipatation: precipatation,
                                                  pressure: pressure,
                                                  visibility: visibility,
                                                  uvIndex: uvIndex)
        return model
    }

    func locationName(filterLocations: LocationFilters) -> String {
        if let cityModel = filterLocations.city {
            return [cityModel.name, cityModel.country].joined(separator: ",")
        } else if let location = filterLocations.location {
            return "\(location.latitude), \(location.longitude)"
        } else {
            return ""
        }
    }

}
