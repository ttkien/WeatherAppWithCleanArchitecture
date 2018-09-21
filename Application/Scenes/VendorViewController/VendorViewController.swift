import UIKit
import Domain
import AERISWeatherRepository
import DarkSkyRepository
import Platform

class VendorViewController: UIViewController {

    struct Model {
        let vendor: Vendor
        let homePage: String
        let title: String

        public init(vendor: Vendor, homePage: String, title: String) {
            self.vendor = vendor
            self.homePage = homePage
            self.title = title
        }
    }

    @IBOutlet weak var tableView: UITableView!
    var models: [Model] = {
        var models = [Model]()
        models.append(VendorViewController.Model(vendor: Vendor.aerisWeather,
                                                 homePage: "https://www.aerisweather.com",
                                                 title: "AERIS"))
        models.append(VendorViewController.Model(vendor: Vendor.forecastIO,
                                                 homePage: "https://www.forecast.io",
                                                 title: "Dark Sky"))
        return models
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.title = "Search Vendor API"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                                       target: self,
                                                                                       action: #selector(didSelectButtonDone(sender:)))
    }

    @objc func didSelectButtonDone(sender: AnyObject?) {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(Configuration.DID_CHANGE_VENDOR)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension VendorViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let model = self.models[indexPath.row]

        let isSelected = model.vendor == Configuration.sharedInstance.vendor
        if isSelected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        cell.textLabel?.text = model.title
        cell.detailTextLabel?.text = model.homePage
        cell.detailTextLabel?.textColor = UIColor.blue

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.models[indexPath.row]
        Configuration.sharedInstance.vendor = model.vendor

        self.tableView.reloadData()
    }
}
