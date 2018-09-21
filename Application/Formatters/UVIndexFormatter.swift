import Foundation
import Domain

class UVIndexFormatter {
    public static let sharedInstance = UVIndexFormatter()

    func string(from value: Float?) -> String {
        guard let value = value else { return "" }
        return String(format: "%.1f cm", value)
    }
}
