import XCTest
import Domain
import RxBlocking
@testable import AERISWeatherRepository

class AERISWeatherTests: XCTestCase {

    override func setUp() {
        super.setUp()

        AERISApiClientInitializer.initialize(with: "Hcslj7VT1voFi1aaaqRxX", secret: "FLMd6w3BV99I1CIQtlt0Rk1pxfM2Yhz8VZzeWxNE")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetDailyWeather() {
        var filters = LocationFilters()
        filters.city = CityModel(name: "toronto", country: "canada")
        let predictionResult = try! WeatherRepository().getDailyWeather(numbersOfNextDays: 14, locationFilter: filters).toBlocking().first()!
        XCTAssertNotNil(predictionResult)

    }

    func testGetHourlyWeather() {
        var filters = LocationFilters()
        filters.city = CityModel(name: "toronto", country: "canada")
        let predictionResult = try! WeatherRepository().getHourlyWeather(hourInterval: 1,
                                                                         limit: 24,
                                                                         locationFilter: filters)
            .toBlocking().first()!
        XCTAssertNotNil(predictionResult)

    }

    func testGetCurrentWeather() {
        var filters = LocationFilters()
        filters.city = CityModel(name: "toronto", country: "canada")
        let predictionResult = try! WeatherRepository().getCurrentWeather(locationFilter: filters).toBlocking().first()!
        XCTAssertNotNil(predictionResult)
    }

}
