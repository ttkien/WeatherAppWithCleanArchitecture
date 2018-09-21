import Foundation
import XCTest
import Domain
@testable import Weather

class WindFormatterTest : XCTestCase {

    func testStringFromValue() {
        XCTAssertEqual(WindFormatter.sharedInstance.string(from: nil), "")
        XCTAssertEqual(WindFormatter.sharedInstance.string(from: WindModel(direction: "W", velocity: 1)), "W 1.0m/s")
        XCTAssertEqual(WindFormatter.sharedInstance.string(from: WindModel(direction: "W", velocity: 1.2345)), "W 1.2m/s")
    }
}
