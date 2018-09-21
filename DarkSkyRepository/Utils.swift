import Foundation

class Utils {
    public static func convertMPHToMPS(mph: Float) -> Float {
        //1 km 1 hours
        // 1 m 3.6m
        return mph * 1609 / 3600
    }
}
