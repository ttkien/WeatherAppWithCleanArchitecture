import Foundation
import Domain

class SunriseFormatter {
    public static let sharedInstance = SunriseFormatter()
    private let hourMinuteFormatter = HourMiniuteFormatter()

    func string(from date: Date?) -> String {
        return hourMinuteFormatter.string(from: date)
    }
}
