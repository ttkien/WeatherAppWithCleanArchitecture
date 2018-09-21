import XCTest
import GooglePlaces
import GoogleMaps
import RxBlocking
import Domain

@testable import SearchCityRepository

class SearchCityRepositoryTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        SearchCityRepositoryInitializer.initialize(googleAPIKey: "AIzaSyDyp4K2oq2GDsHRIzy7Qpt87gGmlCRnvuI")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSearchCityWithSearchText() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let citys = try! SearchCityRepository().searchCity(searchText: "Ha noi").toBlocking().first()

        print(citys?.first?.name == "Hanoi")
    }

    func testSearchCityWithLocation() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let location = CLLocationCoordinate2D(latitude: 40.437500, longitude: -3.681800)
        let city = try! SearchCityRepository().searchCity(location: location).toBlocking().first()!

        print(city!.name == "Marid")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
