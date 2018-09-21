import Foundation
import UIKit

class DataNotFoundView : UIView {
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func showIcon(image: UIImage) {
        self.iconImageView.image = image
        self.iconImageView.isHidden = false
    }
    
    func showMainTitle(title: String) {
        self.mainTitleLabel.text = title
        self.mainTitleLabel.isHidden = false
    }
    
    func showSubTitle(title: String) {
        self.subTitleLabel.text = title
        self.subTitleLabel.isHidden = false
    }
}
