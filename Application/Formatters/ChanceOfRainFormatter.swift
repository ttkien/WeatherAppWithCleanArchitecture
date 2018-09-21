import Foundation
import Domain

class ChanceOfRainFormatter {
    public static let sharedInstance = ChanceOfRainFormatter()

    func string(from value: Float?) -> String {
        guard let value = value else { return "" }
        return "\(Int(value * 100))%"
    }
}
