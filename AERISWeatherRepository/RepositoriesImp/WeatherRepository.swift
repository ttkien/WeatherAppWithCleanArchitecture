import Foundation
import Domain
import RxSwift
import AerisWeatherKit

public class WeatherRepository: WeatherRepositoryProtocol {

    public init() {

    }

    public func getDailyWeather(numbersOfNextDays: Int, locationFilter: LocationFilters) -> Observable<[DailyPredictionResult]> {
        guard let place = self.getAWFPlace(from: locationFilter) else {
            return Observable.error(NSError(
                domain: String(describing: self),
                code: 0x0,
                userInfo: [NSLocalizedDescriptionKey: "location should have city or location"
                ]))
        }

        let dailyOptions = AWFWeatherRequestOptions()
        dailyOptions.limit = UInt(numbersOfNextDays)
        dailyOptions.filterString = "\(AWFForecastFilter.day)"
        return Observable.create({ (observer) -> Disposable in

            let disposable = Disposables.create()
            AWFForecasts.sharedService().get(forPlace: place,
                                          options: dailyOptions) {[weak self] (result) in
                                            guard let strongSelf = self else {
                                                observer.onNext([])
                                                return
                                            }
                                            defer {
                                                disposable.dispose()
                                            }

                                            guard let results = result?.results else {
                                                observer.onNext([])
                                                return
                                            }

                                            guard let forecast = results.first as? AWFForecast,
                                                let forecastPeriods = forecast.periods else {
                                                    observer.onNext([])
                                                    return
                                            }

                                            do {
                                            let predictionResults = try forecastPeriods.map({ (forecastPeriod) -> DailyPredictionResult in
                                                return try strongSelf.tranformForecastToDailyPredictionResult(forecastPeriod: forecastPeriod)
                                            })

                                            observer.onNext(predictionResults)
                                            } catch {
                                                observer.onError(error)
                                            }
            }
            return disposable
        })
    }

    fileprivate func tranformForecastToDailyPredictionResult(forecastPeriod: AWFForecastPeriod) throws -> DailyPredictionResult {
        guard let timestamp = forecastPeriod.timestamp else {
            throw NSError(domain: String(describing: self),
                          code: 0x0,
                          userInfo: [NSLocalizedDescriptionKey: "timestamp must be not null"])
        }

        let win = createWin(from: forecastPeriod)
        let humidity = createHumidity(from: forecastPeriod)
        let cloudiness = createCloudiness(from: forecastPeriod)
        let temperature = createTemperature(from: forecastPeriod)
        let weather = createWeather(from: forecastPeriod)

        return DailyPredictionResult(wind: win,
                                     humidity: humidity,
                                     cloudiness: cloudiness,
                                     temperature: temperature,
                                     weather: weather,
                                     predictAtDay: timestamp)
    }

    public func getHourlyWeather(hourInterval: Int, limit: Int, locationFilter: LocationFilters) -> Observable<[HourlyPredictionResult]> {
        guard let place = self.getAWFPlace(from: locationFilter) else {
            return Observable.error(NSError(
                domain: String(describing: self),
                code: 0x0,
                userInfo: [NSLocalizedDescriptionKey: "location should have city or location"
                ]))
        }

        let hourlyOptions = AWFWeatherRequestOptions()
        hourlyOptions.limit = UInt(limit)
        hourlyOptions.filterString = "\(hourInterval)hr"
        return Observable.create({ (observer) -> Disposable in

            let disposable = Disposables.create()
            AWFForecasts.sharedService().get(forPlace: place,
                                          options: hourlyOptions) {[weak self] (result) in
                                            guard let strongSelf = self else {
                                                observer.onNext([])
                                                return
                                            }
                                            defer {
                                                disposable.dispose()
                                            }

                                            guard let results = result?.results else {
                                                observer.onNext([])
                                                return
                                            }

                                            guard let forecast = results.first as? AWFForecast,
                                                let forecastPeriods = forecast.periods else {
                                                    observer.onNext([])
                                                    return
                                            }

                                            do {
                                            let predictionResults = try forecastPeriods.map({ (forecastPeriod) -> HourlyPredictionResult in
                                                print(forecastPeriod.timestamp!)
                                                return try strongSelf.tranformForecastToHourlyPredictionResult(forecastPeriod: forecastPeriod)
                                            })

                                            observer.onNext(predictionResults)
                                            } catch {
                                                observer.onError(error)
                                            }
            }
            return disposable
        })
    }

    private func getCurrenyWeatherInHourly(locationFilter: LocationFilters) -> Observable<AWFForecastPeriod?> {
        guard let place = self.getAWFPlace(from: locationFilter) else {
            return Observable.error(NSError(
                domain: String(describing: self),
                code: 0x0,
                userInfo: [NSLocalizedDescriptionKey: "location should have city or location"
                ]))
        }

        return Observable.create({ (observer) -> Disposable in

            let disposable = Disposables.create()
            let options = AWFWeatherRequestOptions()
            options.limit = 1
            options.filterString = "1h"

            AWFForecasts.sharedService().get(forPlace: place,
                                             options: options) {[weak self] (result) in
                                                defer {
                                                    disposable.dispose()
                                                }

                                                guard let results = result?.results else {
                                                    observer.onNext(nil)
                                                    return
                                                }

                                                guard let forecast = results.first as? AWFForecast,
                                                    let forecastPeriod = forecast.periods?.first else {
                                                        observer.onNext(nil)
                                                        return
                                                }

                                                observer.onNext(forecastPeriod)
            }
            return disposable
        })
    }

    private func getCurrenyWeatherInDaily(locationFilter: LocationFilters) -> Observable<AWFForecastPeriod?> {
        guard let place = self.getAWFPlace(from: locationFilter) else {
            return Observable.error(NSError(
                domain: String(describing: self),
                code: 0x0,
                userInfo: [NSLocalizedDescriptionKey: "location should have city or location"
                ]))
        }

        return Observable.create({ (observer) -> Disposable in

            let disposable = Disposables.create()
            let options = AWFWeatherRequestOptions()
            options.limit = 1
            options.filterString = "day"

            AWFForecasts.sharedService().get(forPlace: place,
                                             options: options) {[weak self] (result) in
                                                defer {
                                                    disposable.dispose()
                                                }

                                                guard let results = result?.results else {
                                                    observer.onNext(nil)
                                                    return
                                                }

                                                guard let forecast = results.first as? AWFForecast,
                                                    let forecastPeriod = forecast.periods?.first else {
                                                        observer.onNext(nil)
                                                        return
                                                }
                                                observer.onNext(forecastPeriod)
            }
            return disposable
        })
    }

    public func getCurrentWeather(locationFilter: LocationFilters) -> Observable<PredictionResult?> {
        return Observable.zip(self.getCurrenyWeatherInHourly(locationFilter: locationFilter),
                              self.getCurrenyWeatherInDaily(locationFilter: locationFilter))
            .map({ (hourly, daily) -> PredictionResult? in
                guard let hourly = hourly else {
                    return nil
                }
                let predicationResult = self.tranformForecastToPredictionResult(forecastPeriodInHourly: hourly,
                                                               forecastPeriodIDaily: daily)
                return predicationResult
            })
    }

    fileprivate func createHunidity(_ forecastPeriod: AWFForecastPeriod) -> HumidityModel {
        return HumidityModel(value: Float(forecastPeriod.humidity))
    }

    fileprivate func tranformForecastToHourlyPredictionResult(forecastPeriod: AWFForecastPeriod) throws -> HourlyPredictionResult {
        guard let timestamp = forecastPeriod.timestamp else {
            throw NSError(domain: String(describing: self),
                          code: 0x0,
                          userInfo: [NSLocalizedDescriptionKey: "timestamp must be not null"])
        }
        let win = createWin(from: forecastPeriod)
        let humidity = createHunidity(forecastPeriod)
        let cloudiness = createCloudiness(from: forecastPeriod)
        let temperature = createTemperature(from: forecastPeriod)
        let weather = createWeather(from: forecastPeriod)

        return HourlyPredictionResult(predictAtHour: timestamp,
                                      wind: win,
                                      humidity: humidity,
                                      cloudiness: cloudiness,
                                      temperature: temperature,
            weather: weather)
    }

    func tranformForecastToPredictionResult(forecastPeriodInHourly: AWFForecastPeriod,
                                            forecastPeriodIDaily: AWFForecastPeriod?) -> PredictionResult {
        let win = createWin(from: forecastPeriodInHourly)
        let humidity = createHumidity(from: forecastPeriodInHourly)
        let cloudiness = createCloudiness(from: forecastPeriodInHourly)
        let temperature = TemperaturModel(minTemC: (forecastPeriodIDaily?.minTempC).map { Float($0) },
                                          maxTemC: (forecastPeriodIDaily?.maxTempC).map {  Float($0) },
                                          temC: Float(forecastPeriodInHourly.tempC))
        let weather = createWeather(from: forecastPeriodInHourly)

        let sunrise = forecastPeriodIDaily?.sunrise
        let sunset = forecastPeriodIDaily?.sunset
        return PredictionResult(wind: win,
                                humidity: humidity,
                                cloudiness: cloudiness,
                                temperature: temperature,
                                weather: weather,
                                sunrise: sunrise,
                                sunset: sunset,
                                feelLike: Float(forecastPeriodInHourly.feelslikeC),
                                precipatation: Float(forecastPeriodInHourly.precipMM),
                                pressure: Float(forecastPeriodInHourly.pressureMB),
                                visibility: nil,
                                uvIndex: nil)
    }

    func convertCloudsCodedToDescription(cloudsCoded: String) -> CloudinessType {
        return Constants.CloudinessCodeAndDescriptionMapping[cloudsCoded] ?? .unknown
    }

    func getAWFPlace(from locationFilter: LocationFilters) -> AWFPlace? {
        if let city = locationFilter.city {
            return AWFPlace(city: city.name, state: nil, country: city.country)
        } else if let location = locationFilter.location {
            return AWFPlace(coordinate: location)
        } else {
            return nil
        }
    }

   fileprivate func createWin(from forecastPeriod: AWFForecastPeriod) -> WindModel {
        return WindModel(direction: forecastPeriod.windDirection ?? "" ,
                         velocity: Utils.convertKPHToMPS(kph: Float(forecastPeriod.windSpeedKMH)))
    }

    fileprivate func createHumidity(from forecastPeriod: AWFForecastPeriod) -> HumidityModel {
        return HumidityModel(value: Float(forecastPeriod.humidity / 100))
    }

    fileprivate func createCloudiness(from forecastPeriod: AWFForecastPeriod) -> CloudinessModel {
        let cloudinessDescription = forecastPeriod.cloudsCoded
            .map { (cloudCoded) -> CloudinessType in
                self.convertCloudsCodedToDescription(cloudsCoded: cloudCoded)
        } ?? CloudinessType.unknown

        let cloudiness = CloudinessModel(type: cloudinessDescription)
        return cloudiness
    }

    fileprivate func createTemperature(from forecastPeriod: AWFForecastPeriod) -> TemperaturModel {
        let temperaturModel = TemperaturModel(minTemC: Float(forecastPeriod.minTempC),
                                         maxTemC: Float(forecastPeriod.maxTempC),
                                         temC: Float(forecastPeriod.tempC))
        return temperaturModel
    }

    fileprivate func createWeather(from forecastPeriod: AWFForecastPeriod) -> WeatherModel {
        let codes = forecastPeriod.weatherCoded?.components(separatedBy: ":")

        var weatherType = self.weatherType(weatherCodeds: codes)
        if weatherType == .unknown {
            weatherType = self.weatherType(weather: forecastPeriod.weather ?? "")
        }
        let weather = WeatherModel(type: weatherType,
                                   chanceOfRain: tranformPopToChanceOfRain(pop: forecastPeriod.pop))
        return weather
    }

    func tranformPopToChanceOfRain(pop: CGFloat?) -> Float? {
        return pop.map { Float($0 / 100)}
    }

    func weatherType(weatherCodeds: [String]?) -> WeatherType {
        guard let weatherCodeds = weatherCodeds else {
            return .unknown
        }

        for weatherCoded in weatherCodeds {
        let type = Constants.WeatherCodedAndWeatherTypemapping[weatherCoded] ?? .unknown

        switch type {
        case .unknown:
            print("unknown weahter code \(weatherCoded)")
        default:
            return type
        }
        }

        return .unknown
    }

    func weatherType(weather: String) -> WeatherType {
        for (weatherType, keywords) in Constants.WeatherAndWeatherTypemapping {
            let isMatchKeyword = keywords.filter { (keyword) -> Bool in
                return weather.localizedCaseInsensitiveContains(keyword)
                }.isEmpty == false

            if  isMatchKeyword {
                return weatherType
            }
        }

        return .unknown
    }
}
