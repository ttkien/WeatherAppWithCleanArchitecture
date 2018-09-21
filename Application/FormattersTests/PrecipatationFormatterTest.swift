import Foundation
import XCTest
@testable import Weather

class PrecipatationFormatterTest : XCTestCase {

    func testStringFromValue() {
        XCTAssertEqual(PrecipatationFormatter.sharedInstance.string(from: nil), "")
        XCTAssertEqual(PrecipatationFormatter.sharedInstance.string(from: 3), "300.0 cm")
        XCTAssertEqual(PrecipatationFormatter.sharedInstance.string(from: 3.14), "314.0 cm")
    }
}
