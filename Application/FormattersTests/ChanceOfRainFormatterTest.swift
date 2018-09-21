import Foundation
import XCTest
@testable import Weather

class ChanceOfRainFormatterTest : XCTestCase {

    func testStringFromValue() {
        XCTAssertEqual(ChanceOfRainFormatter.sharedInstance.string(from: nil), "")
        XCTAssertEqual(ChanceOfRainFormatter.sharedInstance.string(from: 0.9), "90%")
    }
}
