import Foundation
import Domain

class Constants {
    public static func title(from cloudiness: CloudinessType) -> String {
        switch cloudiness {
        case .clear:
            return "clear"
        case .sunny:
            return "sunny"
        case .partlyCloudy:
            return "partly cloud"
        case .mostlyCloudy:
            return "mostly cloud"
        case .overcast:
            return "overcast"
        case .unknown:
            return "unknown"
        }
    }
}
