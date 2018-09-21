import Foundation

extension Date {
    public static func isSameDate(date1: Date, date2: Date, timeZone: TimeZone = TimeZone.current) -> Bool {
        let calendar = Calendar.current
        let dateComponentsDate1 = calendar.dateComponents(in: timeZone, from: date1)
        let dateComponentsDate2 = calendar.dateComponents(in: timeZone, from: date2)

        return dateComponentsDate1.day == dateComponentsDate2.day
    }
}
