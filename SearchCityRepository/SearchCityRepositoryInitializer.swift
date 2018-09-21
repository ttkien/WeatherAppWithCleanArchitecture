import Foundation
import GooglePlaces
import GoogleMaps

public class SearchCityRepositoryInitializer {
    public static func initialize(googleAPIKey: String) {
        GMSPlacesClient.provideAPIKey(googleAPIKey)
        GMSServices.provideAPIKey(googleAPIKey)
    }
}
