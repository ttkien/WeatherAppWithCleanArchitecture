import Foundation
import AerisWeatherKit

public class AERISApiClientInitializer {
    public static func initialize(with apiKey: String, secret: String) {
        AerisWeather.start(withApiKey: apiKey, secret: secret)
    }
}
