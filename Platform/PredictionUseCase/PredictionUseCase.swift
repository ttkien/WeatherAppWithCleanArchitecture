import Foundation
import Domain
import RxSwift

public class PredictionUseCase: Domain.PredictionUseCaseProtocol {

    let predictionRepository: WeatherRepositoryProtocol
    public init(predictionRepository: WeatherRepositoryProtocol) {
        self.predictionRepository = predictionRepository
    }

    public func getCurrentWeather(location: LocationFilters) -> Observable<PredictionResult?> {
        return self.predictionRepository.getCurrentWeather(locationFilter: location)
    }

    public func getTodayWeather(location: LocationFilters) -> Observable<TodayWeatherResult?> {

        return self.predictionRepository.getHourlyWeather(hourInterval: 1,
                                                          limit: 24,
                                                          locationFilter: location)
            .map({ (hourly) -> TodayWeatherResult in
                return TodayWeatherResult(hourlyPredictionItem: hourly)
            })
    }

    public func getWeekWeatherResult(location: LocationFilters) -> Observable<WeekWeatherResult?> {
        return self.predictionRepository.getDailyWeather(numbersOfNextDays: 7, locationFilter: location)
            .map({ (dailyPredictionReuslts) -> WeekWeatherResult? in
                return WeekWeatherResult.init(dailyPredictionItem: dailyPredictionReuslts)
            })
    }

    public func getMonthWeatherResult(location: LocationFilters) -> Observable<MonthWeatherResult?> {
        return Observable.error(NSError(domain: "PredictionUseCase",
                                        code: 0x0,
                                        userInfo: [NSLocalizedDescriptionKey: "Not implement"]))
    }
}
