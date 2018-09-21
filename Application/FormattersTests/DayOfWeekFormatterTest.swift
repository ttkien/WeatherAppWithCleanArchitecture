import Foundation
import XCTest
@testable import Weather

class DayOfWeekFormatterTest : XCTestCase {

    func testStringFromValue() {
        XCTAssertEqual(DayOfWeekFormatter.sharedInstance.string(from: nil), "")

        let dateComponents = DateComponents(calendar: Calendar.current,
                                            timeZone: TimeZone.current,
                                            year: 2020,
                                            month: 12,
                                            day: 30,
                                            hour: 6,
                                            minute: 59,
                                            second: 59)

        XCTAssertEqual(DayOfWeekFormatter.sharedInstance.string(from: dateComponents.date), "Wednesday")
    }
}
