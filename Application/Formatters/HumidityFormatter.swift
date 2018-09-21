import Foundation
import Domain

class HumidityFormatter {
    public static let sharedInstance = HumidityFormatter()

    func string(from value: HumidityModel?) -> String {
        guard let float = value?.value else { return "" }
        return "\(Int(float * 100))%"
    }
}
