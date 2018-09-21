import Foundation
import XCTest
@testable import Weather

class TemperatureFormatterTest : XCTestCase {

    func testStringFromValue() {
        XCTAssertEqual(TemperatureFormatter.sharedInstance.string(from: nil), "")
        XCTAssertEqual(TemperatureFormatter.sharedInstance.string(from: 3), "3\u{00B0}")
        XCTAssertEqual(TemperatureFormatter.sharedInstance.string(from: 3.14), "3\u{00B0}")
    }
}
