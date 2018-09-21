import Foundation

class Utils {
    public static func convertKPHToMPS(kph: Float) -> Float {
        //1 km 1 hours
        // 1 m 3.6m
        return kph * 1000 / 3600
    }
}
