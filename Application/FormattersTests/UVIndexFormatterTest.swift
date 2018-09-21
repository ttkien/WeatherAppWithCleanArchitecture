import Foundation
import XCTest
@testable import Weather

class UVIndexFormatterTest : XCTestCase {

    func testStringFromValue() {
        XCTAssertEqual(UVIndexFormatter.sharedInstance.string(from: nil), "")
        XCTAssertEqual(UVIndexFormatter.sharedInstance.string(from: 3), "3.0 cm")
        XCTAssertEqual(UVIndexFormatter.sharedInstance.string(from: 3.14), "3.1 cm")
    }
}
