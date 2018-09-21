import Foundation

class WeatherDetailItemView : UIView {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    public override var intrinsicContentSize: CGSize {
        return self.stackView.intrinsicContentSize
    }

    func commonInit() {
        Bundle(for: WeatherDetailItemView.self).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().inset(4)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
        }
    }
}
