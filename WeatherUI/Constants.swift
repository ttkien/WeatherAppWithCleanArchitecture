import Foundation

class TemperatureFormatter {
    func string(for value: Float) -> String {
        return "\(Int(value))\(Constants.temperatureUnit)"
    }
}

class Constants {
    public static let temperatureUnit = "\u{00B0}"
}
