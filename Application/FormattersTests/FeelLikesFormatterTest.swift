import Foundation
import XCTest
@testable import Weather

class FeelLikesFormatterTest : XCTestCase {

    func testStringFromValue() {
        XCTAssertEqual(FeelLikesFormatter.sharedInstance.string(from: nil), "")
        XCTAssertEqual(FeelLikesFormatter.sharedInstance.string(from: 3), "3\u{00B0}")
        XCTAssertEqual(FeelLikesFormatter.sharedInstance.string(from: 3.14), "3\u{00B0}")
    }
}
