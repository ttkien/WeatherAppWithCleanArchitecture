import Foundation
import Domain
import WeatherUI

protocol HourlyWeatherlPresentModelTranformerProtocol {
    func tranform(predictionResult: HourlyPredictionResult) -> HourlyWeatherViewCollectionCellPresentModel 
}

class HourlyWeatherlPresentModelTranformer : HourlyWeatherlPresentModelTranformerProtocol {
    func tranform(predictionResult: HourlyPredictionResult) -> HourlyWeatherViewCollectionCellPresentModel {

        let image = (predictionResult.weather?.type).map({ (weatherType) -> UIImage in
            return UIImage.image(from: weatherType)
        }) ?? UIImage()

        let temperature = TemperatureFormatter.sharedInstance.string(from: predictionResult.temperature?.temC)

        let hour: String
        if isTheSameHour(date1: Date(), date2: predictionResult.predictAtHour) {
            hour = "Now"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            hour = dateFormatter.string(from: predictionResult.predictAtHour)
        }

        let chanceOfRain = ChanceOfRainFormatter.sharedInstance.string(from: predictionResult.weather?.chanceOfRain)
        let model = HourlyWeatherViewCollectionCellPresentModel(
            hour: hour,
            percentage: chanceOfRain,
            weatherImage: image,
            temperature: temperature)

        return model
    }

    func isTheSameHour(date1: Date, date2: Date) -> Bool {
        let dateComponents1 = Calendar.current.dateComponents(in: TimeZone.current, from: date1)
        let dateComponents2 = Calendar.current.dateComponents(in: TimeZone.current, from: date2)
        return dateComponents1.year == dateComponents2.year
            && dateComponents1.month == dateComponents2.month
            && dateComponents1.day == dateComponents2.day
            && dateComponents1.hour == dateComponents2.hour
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
