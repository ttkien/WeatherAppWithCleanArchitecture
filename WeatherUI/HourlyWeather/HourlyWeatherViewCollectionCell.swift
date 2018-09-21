import Foundation
import UIKit

public struct HourlyWeatherViewCollectionCellPresentModel {
    public let hour: String
    public let percentage: String
    public let weatherImage: UIImage
    public let temperature: String

    public init(hour: String, percentage: String, weatherImage: UIImage, temperature: String) {
        self.hour = hour
        self.percentage = percentage
        self.weatherImage = weatherImage
        self.temperature = temperature
    }
}

class HourlyWeatherViewCollectionCell : UICollectionViewCell {
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 76, height: 110)
    }

    func bind(model: HourlyWeatherViewCollectionCellPresentModel) {
        self.hourLabel.text = model.hour
        self.percentageLabel.text = model.percentage
        self.weatherImageView.image = model.weatherImage
        self.temperatureLabel.text = model.temperature
    }

}
