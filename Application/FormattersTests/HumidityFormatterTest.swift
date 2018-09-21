import Foundation
import XCTest
import Domain
@testable import Weather

class HumidityFormatterTest : XCTestCase {

    func testStringFromValue() {
        XCTAssertEqual(HumidityFormatter.sharedInstance.string(from: nil), "")
        XCTAssertEqual(HumidityFormatter.sharedInstance.string(from: HumidityModel(value: 0.9)), "90%")
        XCTAssertEqual(HumidityFormatter.sharedInstance.string(from: HumidityModel(value: 0.1)), "10%")
        XCTAssertEqual(HumidityFormatter.sharedInstance.string(from: HumidityModel(value: 0.01)), "1%")
        XCTAssertEqual(HumidityFormatter.sharedInstance.string(from: HumidityModel(value: 0.001)), "0%")

    }
}
