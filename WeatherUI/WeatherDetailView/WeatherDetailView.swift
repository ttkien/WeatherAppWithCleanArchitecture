import UIKit

public struct WeatherDetailViewPresentModel {
    public let chanceOfRain: String
    public let humidity: String
    public let wind: String
    public let cloudiness: String
    public let sunrise: String
    public let sunset: String
    public let feelLike: String
    public let precipatation: String
    public let pressure: String
    public let visibility: String
    public let uvIndex: String

    public init(chanceOfRain: String,
                humidity: String,
                wind: String,
                cloudiness: String,
                sunrise: String,
                sunset: String,
                feelLike: String,
                precipatation: String,
                pressure: String,
                visibility: String,
                uvIndex: String) {
        self.chanceOfRain = chanceOfRain
        self.humidity = humidity
        self.wind = wind
        self.cloudiness = cloudiness
        self.sunrise = sunrise
        self.sunset = sunset
        self.feelLike = feelLike
        self.precipatation = precipatation
        self.pressure = pressure
        self.visibility = visibility
        self.uvIndex = uvIndex
    }

}

public class WeatherDetailView : UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var chanceOfRainItemView : WeatherDetailItemView!
    @IBOutlet weak var humidityLabelItemView: WeatherDetailItemView!
    @IBOutlet weak var windLabelItemView: WeatherDetailItemView!
    @IBOutlet weak var sunriseItemView: WeatherDetailItemView!
    @IBOutlet weak var sunsetItemView: WeatherDetailItemView!
    @IBOutlet weak var feelLikeItemView: WeatherDetailItemView!

    @IBOutlet weak var precipatationItemView: WeatherDetailItemView!
    @IBOutlet weak var pressureItemView: WeatherDetailItemView!
    @IBOutlet weak var visibilityItemView: WeatherDetailItemView!
    @IBOutlet weak var uvIndexItemView: WeatherDetailItemView!

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 300)
    }

    func commonInit() {
        Bundle(for: WeatherDetailView.self).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.snp.margins)
        }

        self.sunriseItemView.titleLabel.text = "Sunrise"
        self.sunsetItemView.titleLabel.text = "Sunset"
        self.chanceOfRainItemView.titleLabel.text = "Chance of Rain"
        self.humidityLabelItemView.titleLabel.text = "Humidity"
        self.windLabelItemView.titleLabel.text = "Wind"
        self.feelLikeItemView.titleLabel.text = "Feels like"
        self.precipatationItemView.titleLabel.text = "Precipatation"
        self.pressureItemView.titleLabel.text = "Pressure"
        self.visibilityItemView.titleLabel.text = "Visibility"
        self.uvIndexItemView.titleLabel.text = "UV Index"

    }

    public func bind(model: WeatherDetailViewPresentModel) {
        self.sunriseItemView.valueLabel.text = model.sunrise
        self.sunsetItemView.valueLabel.text = model.sunset
        self.chanceOfRainItemView.valueLabel.text = model.chanceOfRain
        self.humidityLabelItemView.valueLabel.text = model.humidity
        self.windLabelItemView.valueLabel.text = model.wind
        self.feelLikeItemView.valueLabel.text = model.feelLike
        self.precipatationItemView.valueLabel.text = model.precipatation
        self.pressureItemView.valueLabel.text = model.pressure
        self.visibilityItemView.valueLabel.text = model.visibility
        self.uvIndexItemView.valueLabel.text = model.uvIndex
    }
}
