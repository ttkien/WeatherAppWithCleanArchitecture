import Foundation
import UIKit

public class HourlyWeatherView : UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    public var models: [HourlyWeatherViewCollectionCellPresentModel] = []

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 100)
    }

    func commonInit() {
        Bundle(for: HourlyWeatherViewCollectionCell.self).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let nib = UINib(nibName: String(describing: HourlyWeatherViewCollectionCell.self), bundle: Bundle(for: HourlyWeatherViewCollectionCell.self))
        self.collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 76, height: 110)
        self.collectionView.collectionViewLayout = flowLayout
    }

    public func reloadData() {
        self.collectionView.reloadData()
    }
}

extension HourlyWeatherView : UICollectionViewDelegate {

}

extension HourlyWeatherView : UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.models.count 
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable : force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HourlyWeatherViewCollectionCell
        let model = self.models[indexPath.row]
        cell.bind(model: model)
        return cell
    }

}
