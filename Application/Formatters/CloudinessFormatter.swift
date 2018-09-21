import Foundation
import Domain

class CloudinessFormatter {
    public static let sharedInstance = CloudinessFormatter()

    func string(from value: CloudinessModel?) -> String {
        guard let value = value else { return "" }
        return Constants.title(from: value.type)
    }
}
