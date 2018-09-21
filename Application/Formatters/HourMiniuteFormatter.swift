import Foundation
import Domain

class HourMiniuteFormatter {
    public static let sharedInstance = HourMiniuteFormatter()
    
    private let formatter: DateFormatter = {
        let hoursFormmat = DateFormatter()
        hoursFormmat.dateFormat = "HH:mm"
        return hoursFormmat
    }()

    func string(from date: Date?) -> String {
        guard let date = date else { return "" }
        return self.formatter.string(from: date)
    }
}
