import Foundation
import XCTest
import Domain
@testable import Weather

class CloudinessFormatterTest : XCTestCase {

    func testStringFromValue() {
        XCTAssertEqual(CloudinessFormatter.sharedInstance.string(from: nil), "")
        XCTAssertEqual(
            CloudinessFormatter.sharedInstance.string(from: CloudinessModel(type: CloudinessType.clear)),
            "clear")
    }
}
