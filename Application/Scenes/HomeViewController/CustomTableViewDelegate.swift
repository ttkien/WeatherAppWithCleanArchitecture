import UIKit
import BLKFlexibleHeightBar

class CustomTableViewDelegate: SquareCashStyleBehaviorDefiner, UITableViewDelegate {

    weak var delegate: UITableViewDelegate?

    init(delegate: UITableViewDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.delegate?.tableView?(tableView, viewForHeaderInSection: section)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.delegate?.tableView?(tableView, heightForRowAt: indexPath) ?? 0
    }
    
}
