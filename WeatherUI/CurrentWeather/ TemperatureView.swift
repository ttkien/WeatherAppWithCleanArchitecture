import Foundation
import UIKit
import SnapKit

public class TemperatureView : UIView {

    weak var label: UILabel!

    public var value: String? {

        didSet {

            self.label!.text = value ?? ""
            self.label!.sizeToFit()
            self.label!.snp.remakeConstraints({ (maker) in
                maker.size.equalTo(self.label!.frame.size)
                maker.center.equalToSuperview()
            })
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        self.commonInit()
    }

    func commonInit() {
        let label = UILabel(frame: CGRect.zero)
        label.frame.size = self.bounds.size
        self.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 55)
        self.label = label
    }

}
