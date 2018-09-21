import Foundation
import RxSwift

public protocol WeatherRepositoryProtocol {
    func getDailyWeather(numbersOfNextDays: Int, locationFilter: LocationFilters) -> Observable<[DailyPredictionResult]>
    func getHourlyWeather(hourInterval: Int, limit: Int, locationFilter: LocationFilters) -> Observable<[HourlyPredictionResult]>
    func getCurrentWeather(locationFilter: LocationFilters) -> Observable<PredictionResult?>
}
