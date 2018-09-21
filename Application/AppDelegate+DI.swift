import UIKit
import Domain
import Platform
import DarkSkyRepository
import AERISWeatherRepository
import SearchCityRepository

extension AppDelegate {

    func initDependencyInjection() {
        DarkSkyRepositoryInitializer.initialize(with: Configuration.DARK_SKY_API_KEY)
        AERISApiClientInitializer.initialize(with: Configuration.AERIS_WEATHER_API_KEY, secret: Configuration.AERIS_WEATHER_SECRET_KEY)

        DependencyInjection.sharedInstance.register(PredictionUseCaseProtocol.self) { () -> PredictionUseCaseProtocol in

            switch Configuration.sharedInstance.vendor {
            case .aerisWeather:
                return PredictionUseCase(predictionRepository: AERISWeatherRepository.WeatherRepository())
            case .forecastIO:
                return PredictionUseCase(predictionRepository: DarkSkyRepository.WeatherRepository())
            }
        }

        SearchCityRepositoryInitializer.initialize(googleAPIKey: Configuration.GOOGLE_API_KEY)
        DependencyInjection.sharedInstance.register(PlaceUseCaseProtocol.self) { () -> PlaceUseCaseProtocol in

            PlaceUseCase(placeRepository: SearchCityRepository())
        }

    }
}
