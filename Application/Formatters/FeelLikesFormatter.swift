import Foundation
import Domain

class FeelLikesFormatter {
    public static let sharedInstance = FeelLikesFormatter()

    func string(from value: Float?) -> String {
        guard let value = value else { return "" }
        return  String(format: "%.0f\u{00B0}", value)
    }
}
