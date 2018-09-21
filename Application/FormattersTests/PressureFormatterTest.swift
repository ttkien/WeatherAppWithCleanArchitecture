import Foundation
import XCTest
@testable import Weather

class PressureFormatterTest : XCTestCase {

    func testStringFromValue() {
        XCTAssertEqual(PressureFormatter.sharedInstance.string(from: nil), "")
        XCTAssertEqual(PressureFormatter.sharedInstance.string(from: 3), "3.0 cm")
        XCTAssertEqual(PressureFormatter.sharedInstance.string(from: 3.14), "3.1 cm")
    }
}
