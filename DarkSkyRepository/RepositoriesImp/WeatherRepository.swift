import Foundation
import Domain
import RxSwift
import WXKDarkSky
import CoreLocation

public class WeatherRepository : WeatherRepositoryProtocol {

    public init() {
        
    }

    public func cityNameToCoordinate(cityModel: CityModel) -> Observable<CLLocationCoordinate2D?> {
        return Observable.create({ (observer) -> Disposable in
            let disposable = Disposables.create()
            let geoCoder = CLGeocoder()
            let address = cityModel.name + "," + cityModel.country
            geoCoder.geocodeAddressString(address) { (marks, _) in

                if let city = marks?.filter({ (mark) -> Bool in
                    let isMatchCityName = mark.name?.localizedCaseInsensitiveContains(cityModel.name) ?? false
                    let isHasCoordinate = mark.location?.coordinate != nil
                    return isMatchCityName && isHasCoordinate
                }).first {
                    observer.onNext(city.location?.coordinate)
                } else {
                    observer.onNext(nil)
                }

                disposable.dispose()
            }

            return disposable
        })
    }

    public func locationFilterToLocation(locationFilter: LocationFilters) -> Observable<CLLocationCoordinate2D?> {
        if let location = locationFilter.location {
            return Observable.just(location)
        } else if let city = locationFilter.city {
            return cityNameToCoordinate(cityModel: city)
        } else {
            return Observable.just(nil)
        }
    }

    public func getDailyWeather(numbersOfNextDays: Int, locationFilter: LocationFilters) -> Observable<[DailyPredictionResult]> {
        return self.locationFilterToLocation(locationFilter: locationFilter)
            .flatMap({ (location) -> Observable<[DailyPredictionResult]> in
                guard let location = location else {
                    return Observable.error(NSError(domain: String(describing: WeatherRepository.self),
                                                    code: 0x0,
                                                    userInfo: [NSLocalizedDescriptionKey : "Cannot find location"]))

                }

                return Observable<[DailyPredictionResult]>.create({ (observer) -> Disposable in
                    let disposable = Disposables.create()
                    let request = WXKDarkSkyRequest(key: DarkSkyRepositoryInitializer.apiKey)
                    let point = WXKDarkSkyRequest.Point.init(location.latitude, location.longitude)
                    
                    let options = WXKDarkSkyRequest.Options(exclude: [WXKDarkSkyRequest.DataBlock.alerts, .currently, .hourly, .minutely],
                                                            units: WXKDarkSkyRequest.Units.si)
                    request.loadData(point: point,
                                     time: nil,
                                     options: options,
                                     completionHandler: { (response, error) in
                                        defer {
                                            disposable.dispose()
                                        }
                                        if let error = error {
                                            observer.onError(error)
                                        } else if let data = response?.daily?.data {

                                            let dailyResults = data.map({ (dataPoint) -> DailyPredictionResult in

                                                let wind = self.createWind(dataPoint: dataPoint)
                                                let humidity = self.createHumidity(dataPoint: dataPoint)
                                                let cloudiness = self.createCloudiness(dataPoint: dataPoint)
                                                let temperature = self.createTemperature(dataPoint: dataPoint)
                                                let weather = self.createWeather(dataPoint: dataPoint)
                                                return DailyPredictionResult(wind: wind,
                                                                             humidity: humidity,
                                                                             cloudiness: cloudiness,
                                                                             temperature: temperature,
                                                                             weather: weather,
                                                                             predictAtDay: dataPoint.time)
                                            })

                                            observer.onNext(dailyResults)
                                        } else {
                                            observer.onError(NSError(domain: String(describing: WeatherRepository.self),
                                                                     code: 0x0,
                                                                     userInfo: [NSLocalizedDescriptionKey : "No found data"]))
                                        }

                    })
                    return disposable
                })
            })
    }

    public func getHourlyWeather(hourInterval: Int, limit: Int, locationFilter: LocationFilters) -> Observable<[HourlyPredictionResult]> {
        return self.locationFilterToLocation(locationFilter: locationFilter)
            .flatMap({ (location) -> Observable<[HourlyPredictionResult]> in
                guard let location = location else {
                    return Observable.error(NSError(domain: String(describing: WeatherRepository.self),
                                                    code: 0x0,
                                                    userInfo: [NSLocalizedDescriptionKey : "Cannot find location"]))

                }

                return Observable<[HourlyPredictionResult]>.create({ (observer) -> Disposable in
                    let disposable = Disposables.create()
                    let request = WXKDarkSkyRequest(key: DarkSkyRepositoryInitializer.apiKey)
                    let point = WXKDarkSkyRequest.Point.init(location.latitude, location.longitude)
                    let options = WXKDarkSkyRequest.Options(exclude: [WXKDarkSkyRequest.DataBlock.alerts, .currently, .daily, .minutely],
                                                            units: WXKDarkSkyRequest.Units.si)
                    request.loadData(point: point,
                                     time: nil,
                                     options: options,
                                     completionHandler: { (response, error) in
                                        defer {
                                            disposable.dispose()
                                        }
                                        if let error = error {
                                            observer.onError(error)
                                        } else if let data = response?.hourly?.data {

                                            let hourslyResults = data.map({ (dataPoint) -> HourlyPredictionResult in

                                                let wind = self.createWind(dataPoint: dataPoint)
                                                let humidity = self.createHumidity(dataPoint: dataPoint)
                                                let cloudiness = self.createCloudiness(dataPoint: dataPoint)
                                                let temperature = self.createTemperature(dataPoint: dataPoint)
                                                let weather = self.createWeather(dataPoint: dataPoint)
                                                return HourlyPredictionResult(predictAtHour: dataPoint.time,
                                                                              wind: wind,
                                                                              humidity: humidity,
                                                                              cloudiness: cloudiness,
                                                                              temperature: temperature,
                                                                              weather: weather)
                                            })
                                            observer.onNext(hourslyResults)
                                        } else {
                                            observer.onError(NSError(domain: String(describing: WeatherRepository.self),
                                                                     code: 0x0,
                                                                     userInfo: [NSLocalizedDescriptionKey : "No found data"]))
                                        }

                    })
                    return disposable
                })
            })
    }

    fileprivate func getCurrentWeather(_ location: CLLocationCoordinate2D) -> Observable<PredictionResult?> {
        return Observable<PredictionResult?>.create({ (observer) -> Disposable in
            let disposable = Disposables.create()
            let request = WXKDarkSkyRequest(key: DarkSkyRepositoryInitializer.apiKey)
            let point = WXKDarkSkyRequest.Point.init(location.latitude, location.longitude)
            let options = WXKDarkSkyRequest.Options(
                exclude: [WXKDarkSkyRequest.DataBlock.alerts, .hourly, .minutely],
                units: WXKDarkSkyRequest.Units.si)
            request.loadData(point: point,
                             time: nil,
                             options: options,
                             completionHandler: { (response, error) in
                                defer {
                                    disposable.dispose()
                                }

                                if let error = error {
                                    observer.onError(error)
                                } else if let response = response {
                                    do {
                                    observer.onNext(try self.transformDataPointToPredictionResult(response: response))
                                    } catch {
                                    observer.onError(error)
                                    }
                                } else {
                                    observer.onError(NSError(domain: String(describing: WeatherRepository.self),
                                                             code: 0x0,
                                                             userInfo: [NSLocalizedDescriptionKey : "No found data"]))
                                }

            })
            return disposable
        })
    }

    func transformDataPointToPredictionResult(response: WXKDarkSkyResponse) throws -> PredictionResult {
        guard let currentlyDataPoint = response.currently else {
            throw NSError(domain: String(describing: WeatherRepository.self),
                                           code: 0x0,
                                           userInfo: [NSLocalizedDescriptionKey : "No found data"])
        }

        let wind = self.createWind(dataPoint: currentlyDataPoint)
        let humidity = self.createHumidity(dataPoint: currentlyDataPoint)
        let cloudiness = self.createCloudiness(dataPoint: currentlyDataPoint)

        let minTemC = (response.daily?.data.first?.apparentTemperatureLow).map { Float($0)}
        let maxTemC = (response.daily?.data.first?.apparentTemperatureHigh).map { Float($0)}
        let tem = currentlyDataPoint.temperature.map { Float($0)}

        let temperature = TemperaturModel(minTemC: minTemC, maxTemC: maxTemC, temC: tem)
        let weather = self.createWeather(dataPoint: currentlyDataPoint)
        let result =  PredictionResult(
            wind: wind,
            humidity: humidity,
            cloudiness: cloudiness,
            temperature: temperature,
            weather: weather,
            sunrise: response.daily?.data.first?.sunriseTime,
            sunset: response.daily?.data.first?.sunsetTime,
            feelLike: response.currently?.apparentTemperature.map {Float($0)},
            precipatation: response.currently?.precipIntensity.map {Float($0)},
            pressure: response.currently?.pressure.map {Float($0)},
            visibility: response.currently?.visibility.map {Float($0)},
            uvIndex: response.currently?.uvIndex.map {Float($0)}
        )

        return result
    }

    public func getCurrentWeather(locationFilter: LocationFilters) -> Observable<PredictionResult?> {
        return self.locationFilterToLocation(locationFilter: locationFilter)
            .flatMap({ (location) -> Observable<PredictionResult?> in
                guard let location = location else {
                    return Observable.error(NSError(domain: String(describing: WeatherRepository.self),
                                                    code: 0x0,
                                                    userInfo: [NSLocalizedDescriptionKey : "Cannot find location"]))

                }

                return self.getCurrentWeather(location)
            })
    }

    func createWind(dataPoint: WXKDarkSkyDataPoint) -> WindModel {

        let velocity = dataPoint.windSpeed.map { (mph) -> Float in
            return Utils.convertMPHToMPS(mph: Float(mph))
            } ?? 0

        let direction = dataPoint.windBearing.map { "\($0)\u{00B0}"} ?? ""

        return WindModel(direction: direction, velocity: velocity)
    }

    func createHumidity(dataPoint: WXKDarkSkyDataPoint) -> HumidityModel? {
        return dataPoint.humidity.map {
            HumidityModel(value: Float($0))
        }
    }

    func createCloudiness(dataPoint: WXKDarkSkyDataPoint) -> CloudinessModel {

        let cloudType: CloudinessType
        if let cloudCover = dataPoint.cloudCover {
            if cloudCover <= 0.25 {
                cloudType = .clear
            } else if cloudCover <= 0.5 {
                cloudType = .partlyCloudy
            } else if cloudCover <= 0.75 {
                cloudType = .mostlyCloudy
            } else if cloudCover <= 1 {
                cloudType = .overcast
            } else {
                cloudType = .unknown
            }
        } else {
            cloudType = .unknown
        }

        return CloudinessModel(type: cloudType)
    }

    func createTemperature(dataPoint: WXKDarkSkyDataPoint) -> TemperaturModel? {
        let minTemC = dataPoint.apparentTemperatureLow.map { Float($0)}
        let maxTemC = dataPoint.apparentTemperatureHigh.map { Float($0)}
        let tem = dataPoint.temperature.map { Float($0)}
        return TemperaturModel(minTemC: minTemC, maxTemC: maxTemC, temC: tem)
    }

    func createWeather(dataPoint: WXKDarkSkyDataPoint) -> WeatherModel? {
        let weatherType: WeatherType
        let chanceOfRain: Float? = dataPoint.precipProbability.map { Float($0)}
        if let s = dataPoint.precipType {
            switch s.lowercased() {
            case "rain":
                weatherType = .rain
            case "snow":
                weatherType = .snow
            case "sleet":
                weatherType = .rain
            default:
                weatherType = .clear
            }
        } else {
            weatherType = .clear
        }
        return WeatherModel(type: weatherType, chanceOfRain: chanceOfRain)
    }
}
