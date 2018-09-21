import Foundation
import Domain

class SunsetFormatter {
    public static let sharedInstance = SunsetFormatter()

    private let hourMinuteFormatter = HourMiniuteFormatter()

    func string(from date: Date?) -> String {
        return hourMinuteFormatter.string(from: date)
    }
}
