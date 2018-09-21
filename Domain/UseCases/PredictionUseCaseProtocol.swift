import Foundation
import RxSwift

public protocol PredictionUseCaseProtocol {
    func getCurrentWeather(location: LocationFilters) -> Observable<PredictionResult?>
    func getTodayWeather(location: LocationFilters) -> Observable<TodayWeatherResult?>
    func getWeekWeatherResult(location: LocationFilters) -> Observable<WeekWeatherResult?>
    func getMonthWeatherResult(location: LocationFilters) -> Observable<MonthWeatherResult?>
}
