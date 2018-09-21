import Foundation
import Domain

class VisibilityFormatter {
    public static let sharedInstance = VisibilityFormatter()

    func string(from value: Float?) -> String {
        guard let value = value else { return "" }
    return String(format: "%.1f km", value)

    }
}
