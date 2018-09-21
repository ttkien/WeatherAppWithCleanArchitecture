import Foundation
import UIKit

public class DailyWeatherView : UIView {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var contentView: UIView!

    public var models: [DailyWeatherViewCellPresenter] = []

    public var isScrollEnabled: Bool {
        get {
            return self.tableView.isScrollEnabled
        }
        set {
            self.tableView.isScrollEnabled = newValue
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    func commonInit() {
        Bundle(for: DailyWeatherView.self).loadNibNamed(String(describing: DailyWeatherView.self),
                                                        owner: self,
                                                        options: nil)
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.snp.margins)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: String(describing: DailyWeatherTableViewCell.self),
                        bundle: Bundle(for: DailyWeatherTableViewCell.self))

        self.tableView.register(nib, forCellReuseIdentifier: "Cell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.allowsSelection = false
    }

    override public func sizeToFit() {
        self.tableView.frame.size.height = 0
        self.tableView.sizeToFit()
        self.frame.size = tableView.contentSize
        self.contentView.frame.size = self.frame.size
    }

    public func reloadData() {
        self.tableView.reloadData()
    }
}

extension  DailyWeatherView : UITableViewDelegate {

}

extension  DailyWeatherView : UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //swiftlint:disable : force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DailyWeatherTableViewCell

        let model = self.models[indexPath.row]
        cell.bind(model: model)
        return cell
    }
}
