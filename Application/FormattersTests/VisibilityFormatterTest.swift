import Foundation
import XCTest
@testable import Weather

class VisibilityFormatterTest : XCTestCase {

    func testStringFromValue() {
        XCTAssertEqual(VisibilityFormatter.sharedInstance.string(from: nil), "")
        XCTAssertEqual(VisibilityFormatter.sharedInstance.string(from: 3), "3.0 km")
        XCTAssertEqual(VisibilityFormatter.sharedInstance.string(from: 3.14), "3.1 km")
    }
}
