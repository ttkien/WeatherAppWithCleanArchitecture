import UIKit
import Domain

class Configuration {
    public static let DID_CHANGE_VENDOR = Notification(name: Notification.Name("com.abc.weather.configuration.did_change_vendor"))

    public static let DEFAULT_VENDOR = Vendor.aerisWeather
    public static let DEFAULT_LOCATION = LocationFilters(city: CityModel(name: "Ho Chi Minh", country: "VN"), location: nil)
    public static let LOCATION_FILTERS_KEY = "com.abc.weather.configuration.LocationFilters"
    public static let DARK_SKY_API_KEY = "1d73e2f6bdc4ada3e114751790488338"
    public static let AERIS_WEATHER_API_KEY = "Hcslj7VT1voFi1aaaqRxX"
    public static let AERIS_WEATHER_SECRET_KEY = "FLMd6w3BV99I1CIQtlt0Rk1pxfM2Yhz8VZzeWxNE"
    public static let GOOGLE_API_KEY = "AIzaSyDyp4K2oq2GDsHRIzy7Qpt87gGmlCRnvuI"

    public static let  sharedInstance = Configuration()

    var vendor: Vendor {
        get {
            guard let string = self.userDefaults.string(forKey: "Vendor") else {
                return Configuration.DEFAULT_VENDOR
            }

            return Vendor(rawValue: string) ?? Configuration.DEFAULT_VENDOR
        }

        set {
            self.userDefaults.set(newValue.rawValue, forKey: "Vendor")
        }
    }

    var location: LocationFilters {
        get {
            return self.locationFilterFromUserDefault() ?? Configuration.DEFAULT_LOCATION
        }

        set {
            self.set(locationFilters: newValue)
        }
    }

    let userDefaults: UserDefaults
    fileprivate init() {
        self.userDefaults = UserDefaults.standard
    }

    func locationFilterFromUserDefault() -> LocationFilters? {
        guard let jsonData = self.userDefaults.data(forKey: Configuration.LOCATION_FILTERS_KEY) else {
            return nil
        }

        do {
            let jsonDecoder = JSONDecoder()
            let locationFilters = try jsonDecoder.decode(LocationFilters.self, from: jsonData)
            return locationFilters
        } catch {
            return nil
        }
    }

    func set(locationFilters: LocationFilters) {
        let jsonEncoder = JSONEncoder()

        //swiftlint:disable : force_try
        let data  = try! jsonEncoder.encode(locationFilters)
        self.userDefaults.set(data, forKey: Configuration.LOCATION_FILTERS_KEY)

    }
}
