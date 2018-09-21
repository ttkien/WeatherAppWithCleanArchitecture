import Foundation
import UIKit
import BLKFlexibleHeightBar
import RxSwift
import RxCocoa

class CurrentWeatherBottomView : UIView {
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var minTemLabel: UILabel!
    @IBOutlet weak var maxTemLabel: UILabel!
}

public class CurrentWeatherView : BLKFlexibleHeightBar {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet public weak var locationLabel: UILabel!
    @IBOutlet public weak var weatherLabel: UILabel!
    @IBOutlet public weak var temperatureView: TemperatureView!
    @IBOutlet public weak var temperatureViewInAbove: UILabel!

    @IBOutlet var bottomView: CurrentWeatherBottomView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        self.configureBar()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
        self.configureBar()
    }

    public func bind(model: CurrentWeatherViewPresentModel) {

        self.locationLabel.text = model.location
        self.weatherLabel.text = model.weather
        self.temperatureView.value = model.temperature
        self.temperatureViewInAbove.text = model.temperature
        self.bottomView.dayOfWeekLabel.text = model.daysOfWeek
        self.bottomView.todayLabel.text = model.today
        self.bottomView.minTemLabel.text = model.minTem
        self.bottomView.maxTemLabel.text = model.maxTem
    }

    func commonInit() {
        let name = String(describing: type(of: self))
        Bundle(for: CurrentWeatherView.self).loadNibNamed(name, owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

        _ = self.rx.observe(CGFloat.self, "progress")
            .takeUntil(self.rx.deallocated)
            .subscribe {[weak self] (event) in
                switch event {
                case .next(let progress):
                    let alpha = (1 - (progress ?? 0))
                    self?.temperatureView.alpha = alpha
                    self?.bottomView.alpha = alpha
                default:
                    self?.bottomView.alpha = 1
                    self?.temperatureView.alpha = 1
                }

        }

        _ = self.temperatureView.rx.observe(CGFloat.self, "alpha")
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: {[weak self] (alpha) in
                if let alpha = alpha {
                    UIView.animate(withDuration: 0.25, animations: {

                        if alpha == 0 {
                            self?.temperatureViewInAbove.alpha = 1
                        } else {
                            self?.temperatureViewInAbove.alpha = 0

                        }
                    })

                }
            })

        self.temperatureViewInAbove.alpha = 0
    }

    private func configureBar() {
        self.minimumBarHeight = 120
        self.maximumBarHeight = 184
    }

}
