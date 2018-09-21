import UIKit

class DailyWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func bind(model: DailyWeatherViewCellPresenter) {
        self.dayLabel.text = model.day
        self.weatherImage.image = model.weather
        self.maxTemperatureLabel.text = model.maxTemperature
        self.minTemperatureLabel.text = model.minTemperature
    }
}
