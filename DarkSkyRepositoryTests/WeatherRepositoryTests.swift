import XCTest
@testable import DarkSkyRepository
import Domain
import RxBlocking

class WeatherRepositoryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

        DarkSkyRepositoryInitializer.initialize(with: "1d73e2f6bdc4ada3e114751790488338")
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
