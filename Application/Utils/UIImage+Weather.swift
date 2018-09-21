import Foundation
import UIKit
import Domain

extension UIImage {

    private static let mapping: [WeatherType : UIImage] = {

        return [ WeatherType.clear : #imageLiteral(resourceName: "ic_clear"),
                 WeatherType.fog : #imageLiteral(resourceName: "ic_frog"),
                 WeatherType.humidity : #imageLiteral(resourceName: "ic_humidity"),
                 WeatherType.mostlyCloud : #imageLiteral(resourceName: "ic_mostlycloud"),
                 WeatherType.partlyCloud : #imageLiteral(resourceName: "ic_partly_cloud"),
                 WeatherType.rain : #imageLiteral(resourceName: "ic_rain"),
                 WeatherType.sunny : #imageLiteral(resourceName: "ic_sunny"),
                 WeatherType.snow : #imageLiteral(resourceName: "ic_snow"),
                 WeatherType.thunder : #imageLiteral(resourceName: "ic_thunder"),
                 WeatherType.wind : #imageLiteral(resourceName: "ic_wind")
                 ]
    }()
    public static func image(from weatherType: WeatherType) -> UIImage {
        return mapping[weatherType] ?? UIImage()
    }
}
