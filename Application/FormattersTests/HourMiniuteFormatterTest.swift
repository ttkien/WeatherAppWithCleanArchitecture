import Foundation
import XCTest
@testable import Weather

class HourMiniuteFormatterTest : XCTestCase {

    func testStringFromValue() {
        XCTAssertEqual(HourMiniuteFormatter.sharedInstance.string(from: nil), "")


        let dateComponents = DateComponents(calendar: Calendar.current,
                                            timeZone: TimeZone.current,
                                            year: 2020,
                                            month: 12,
                                            day: 30,
                                            hour: 6,
                                            minute: 59,
                                            second: 59)
        
        XCTAssertEqual(HourMiniuteFormatter.sharedInstance.string(from: dateComponents.date), "06:59")
    }
}
