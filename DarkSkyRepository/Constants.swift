import Foundation
import Domain

class Constants {
    typealias Code = String
    static let CloudinessCodeAndDescriptionMapping: [Code : CloudinessType] = [
        "CL":  CloudinessType.clear,
        "FW" : CloudinessType.sunny,
        "SC" : CloudinessType.partlyCloudy,
        "BK" : CloudinessType.mostlyCloudy,
        "OV" : CloudinessType.overcast
    ]

    static let WeatherCodedAndWeatherTypemapping: [String:WeatherType] = {
        return [
            "A" : WeatherType.rain,
            "BD": WeatherType.wind,
            "BN": WeatherType.wind,
            "BR": WeatherType.wind,
            "BS": WeatherType.fog,
            "BY": WeatherType.fog,
            "F": WeatherType.fog,
            "FR": WeatherType.fog,
            "H": WeatherType.rain,
            "IC": WeatherType.snow,
            "IF": WeatherType.snow,
            "IP": WeatherType.snow,
            "K": WeatherType.fog,
            "L": WeatherType.rain,
            "R": WeatherType.rain,
            "RW": WeatherType.rain,
            "RS": WeatherType.rain,
            "SI": WeatherType.snow,
            "WM": WeatherType.snow,
            "S": WeatherType.snow,
            "SW": WeatherType.snow,
            "T": WeatherType.thunder,
            "UP": WeatherType.unknown,
            "VA": WeatherType.fog,
            "WP": WeatherType.thunder,
            "ZL": WeatherType.rain,
            "ZR": WeatherType.rain,
            "ZY": WeatherType.rain
        ]
    }()

    typealias Keyword = String
    static let WeatherAndWeatherTypemapping: [WeatherType:[Keyword]] = {
        return [
            .clear : ["clear"],
            .fog : [],
            .humidity : [],
            .mostlyCloud : ["Mostly cloud", "Cloudy"],
            .partlyCloud : ["partly cloud"],
            .rain : ["rain"],
            .sunny : [],
            .thunder : ["storms"],
            .wind : [],
           .snow : []

        ]
    }()

}
