import Foundation
import Domain

class PrecipatationFormatter {
    public static let sharedInstance = PrecipatationFormatter()

    func string(from value: Float?) -> String {
        guard let value = value else { return "" }
        return String(format: "%.1f cm", value * 100)
    }
}
