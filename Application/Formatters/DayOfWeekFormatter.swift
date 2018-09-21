import Foundation

class DayOfWeekFormatter {
    public static let sharedInstance = DayOfWeekFormatter()
    private let formatter: DateFormatter = {
        let hoursFormmat = DateFormatter()
        hoursFormmat.dateFormat = "EEEE"
        return hoursFormmat
    }()

    func string(from date: Date?) -> String {
        guard let date = date else { return "" }
        return self.formatter.string(from: date)
    }
}
