import Foundation
import Domain

class WindFormatter {
    public static let sharedInstance = WindFormatter()

    func string(from value: WindModel?) -> String {
        guard let value = value else { return "" }
        return String(format: "\(value.direction) %.1fm/s", value.velocity)
    }
}
