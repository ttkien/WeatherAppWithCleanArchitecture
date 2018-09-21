import Foundation
import Domain

class PressureFormatter {
    public static let sharedInstance = PressureFormatter()

    func string(from value: Float?) -> String {
        guard let value = value else { return "" }
        return String(format: "%.1f cm", value)
    }
}
