import Foundation
import WXKDarkSky

public class DarkSkyRepositoryInitializer {
    public private(set) static var apiKey: String = ""

    public static func initialize(with apiKey: String) {
       self.apiKey = apiKey
    }
}
