import Foundation

public struct WeatherModel {
    public let chanceOfRain: Float?
    public let type: WeatherType
    public init(type: WeatherType, chanceOfRain: Float?) {
        self.type = type
        self.chanceOfRain = chanceOfRain
    }
}
