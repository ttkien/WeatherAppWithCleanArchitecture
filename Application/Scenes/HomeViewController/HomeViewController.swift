import UIKit
import WeatherUI
import Domain
import RxSwift
import RxCocoa
import BLKFlexibleHeightBar

class HomeViewController: UIViewController {
    public static let WEATHER_DETAIL_HEIGHT: CGFloat = 300
    
    @IBOutlet var currentWeatherView: CurrentWeatherView!
    @IBOutlet var hourlyWeatherView: HourlyWeatherView!
    @IBOutlet var daillyWeatherView: DailyWeatherView!
    @IBOutlet var weatherDetailView: WeatherDetailView!

    @IBOutlet weak var tableView: UITableView!

    let loadViewPublishRelay = PublishRelay<Void>()
    let locationFiltersPublishRelay = PublishRelay<LocationFilters>()
    var delegateSplitter: BLKDelegateSplitter!

    let predictionUseCase = DependencyInjection.sharedInstance.resolve(PredictionUseCaseProtocol.self)
    let disposeBag = DisposeBag()
    var viewModel: HomeViewModel!
    var loadingView: UIView?
    weak var alertController: UIAlertController?

    var currentWeatherPresentModelTranformer: CurrentWeatherPresentModelTranformerProtocol {
        return CurrentWeatherPresentModelTranformer()
    }

    var currentWeatherDetailPresentModelTranformer: CurrentWeatherDetailPresentModelTranformerProtocol {
        return CurrentWeatherDetailPresentModelTranformer()
    }

    var hourlyWeatherlPresentModelTranformer: HourlyWeatherlPresentModelTranformerProtocol {
        return HourlyWeatherlPresentModelTranformer()
    }

    var daillyWeatherlPresentModelTranformer: DailyWeatherlPresentModelTranformerProtocol {
        return DailyWeatherlPresentModelTranformer()
    }

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    fileprivate func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.tableView.sectionHeaderHeight = 110
        self.tableView.estimatedSectionHeaderHeight = 110
        self.tableView.register(UITableViewCell.self , forCellReuseIdentifier: "Cell")
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = AppColors.seperatorColor
        self.tableView.bounces = false
        self.tableView.allowsSelection = false

    }

    func setupCurrentWeatherView() {
        self.currentWeatherView.minimumBarHeight = 120
        self.currentWeatherView.maximumBarHeight = 196

        let behaviorDefiner = CustomTableViewDelegate(delegate: self)
        behaviorDefiner.addSnappingPositionProgress(0.0, forProgressRangeStart: 0.0, end: 0.2)
        behaviorDefiner.addSnappingPositionProgress(1.0, forProgressRangeStart: 0.2, end: 1.0)
        behaviorDefiner.isSnappingEnabled = true
        behaviorDefiner.isElasticMaximumHeightAtTop = true
        self.currentWeatherView.behaviorDefiner = behaviorDefiner
        self.tableView.delegate = behaviorDefiner
        self.delegateSplitter = BLKDelegateSplitter(firstDelegate: behaviorDefiner, secondDelegate: self)

        self.currentWeatherView.rx
            .observe(CGRect.self, "frame")
            .subscribe (onNext: {(rect) in

                if rect != nil {
                    self.tableView.frame.origin.y = self.currentWeatherView.frame.maxY
                    self.tableView.frame.size.height = self.view.frame.height - self.currentWeatherView.frame.maxY
                }
            }).disposed(by: self.disposeBag)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()

        self.navigationController?.isNavigationBarHidden = true

        setupToolbar()
        setupTableView()
        setupCurrentWeatherView()

        self.weatherDetailView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        self.reloadData()

        NotificationCenter.default.rx.notification(Configuration.DID_CHANGE_VENDOR.name)
            .subscribe(onNext: {[weak self] (_) in
            self?.reloadData()
        }).disposed(by: self.disposeBag)
    }

    func setupToolbar() {
        self.navigationController?.isToolbarHidden = false
        self.toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didSelectBarButtonItemSearch(sender:))),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didSelectBarButtonItemAction(sender:)))

        ]
    }
    @objc func didSelectBarButtonItemSearch(sender: AnyObject?) {
        let placeSearchController = PlaceSearchController()
        placeSearchController.viewModel = PlaceSearchViewModel.init()
        placeSearchController.delegate = self

        let navigationController = UINavigationController(rootViewController: placeSearchController)
        self.present(navigationController, animated: true, completion: nil)
    }

    @objc func didSelectBarButtonItemAction(sender: AnyObject?) {
        let vendorViewController = VendorViewController()
        let navigationController = UINavigationController(rootViewController: vendorViewController)
        self.present(navigationController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.currentWeatherView.progress = 0
        self.currentWeatherView.frame.size.width = self.tableView.frame.size.width
        self.hourlyWeatherView.frame.size.width = self.tableView.frame.size.width
        self.daillyWeatherView.frame.size.width = self.tableView.frame.size.width
 
        self.currentWeatherView.layer.addBorder(edge: UIRectEdge.top,
                                                color: AppColors.seperatorColor,
                                                    thickness: 1)
        self.hourlyWeatherView.layer.addBorder(edge: UIRectEdge.top,
                                               color: AppColors.seperatorColor,
                                                thickness: 1)
        self.hourlyWeatherView.layer.addBorder(edge: UIRectEdge.bottom ,
                                               color: AppColors.seperatorColor,
                                               thickness: 1)
        self.daillyWeatherView.layer.addBorder(edge: UIRectEdge.top,
                                                color: AppColors.seperatorColor,
                                                thickness: 1)
        self.weatherDetailView.layer.addBorder(edge: UIRectEdge.top,
                                               color: AppColors.seperatorColor,
                                               thickness: 1)
    }
}

// Marks: Reload data
extension HomeViewController {

    func reloadData() {
        self.loadViewPublishRelay.accept(())
    }

    func update(dailyPredictionItem: [DailyPredictionResult]?) {

        let models = (dailyPredictionItem ?? [])
            .map({ (dailyResult) -> DailyWeatherViewCellPresenter in
                return self.daillyWeatherlPresentModelTranformer.tranform(dailyResult: dailyResult)
            })

        self.daillyWeatherView.models = models
        self.daillyWeatherView.reloadData()
        self.daillyWeatherView.sizeToFit()
        self.daillyWeatherView.snp.remakeConstraints { (maker) in
            maker.height.equalTo(self.daillyWeatherView.frame.height)
            maker.width.equalTo(self.tableView.frame.width)
        }
        self.daillyWeatherView.isScrollEnabled = false
        self.tableView.reloadData()
    }

    func update(hourlyWeathers: [HourlyPredictionResult]) {
        let models = hourlyWeathers.map { (hourlyWeatherResult) -> HourlyWeatherViewCollectionCellPresentModel in
            return self.hourlyWeatherlPresentModelTranformer.tranform(predictionResult: hourlyWeatherResult)
        }
        self.hourlyWeatherView.models = models
        self.hourlyWeatherView.reloadData()
        self.tableView.reloadData()
    }

    fileprivate func updateCurrentWeatherView(_ predictionResult: PredictionResult) {
        let locationFilters = self.viewModel.locationFiltersBehaviorRelay.value
        let model = self.currentWeatherPresentModelTranformer.tranform(locationFilters: locationFilters,
                                                                       predictionResult: predictionResult)
        self.currentWeatherView.bind(model: model)
    }

    fileprivate func updateCurrentWeatherDetailView(_ predictionResult: PredictionResult) {
        let model = self.currentWeatherDetailPresentModelTranformer.tranform(predictionResult: predictionResult)
        self.weatherDetailView.bind(model: model)
        self.weatherDetailView.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.tableView.frame.width)
            maker.height.equalTo(HomeViewController.WEATHER_DETAIL_HEIGHT)
            maker.top.equalTo(8)
            maker.left.equalTo(0)
        }
    }

}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return self.hourlyWeatherView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.hourlyWeatherView.intrinsicContentSize.height
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 37 * 7
        } else {
            return HomeViewController.WEATHER_DETAIL_HEIGHT
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.clipsToBounds = true 
        if indexPath.row == 0 {
            if cell.contentView.subviews.contains(self.daillyWeatherView) == false {

            cell.contentView.addSubview(self.daillyWeatherView)
            cell.setNeedsUpdateConstraints()
            cell.updateConstraints()
            }
        } else if indexPath.row == 1 {
            if cell.contentView.subviews.contains(self.weatherDetailView) == false {

            cell.contentView.addSubview(self.weatherDetailView)
            cell.setNeedsUpdateConstraints()
            cell.updateConstraints()
            }
        }

        return cell
    }
}

extension HomeViewController: BindableType {
    typealias ViewModel = HomeViewModel

    func bindInput() -> HomeViewModel.Input {
        return HomeViewModel.Input(loadView: self.loadViewPublishRelay.asDriver(onErrorJustReturn: ()),
                                   locationFiltersChange: self.locationFiltersPublishRelay.asDriver(onErrorDriveWith: Driver.empty())
        )
    }

    func bind(output: HomeViewModel.Output) {
        output.stateDriver.drive(onNext: {[weak self] (state) in
            self?.update(state: state)
        }).disposed(by: self.disposeBag)
    }

    func update(state: HomeViewModel.State) {

        if state.isError {
            self.showError(message: "An error has occured. Please try again.")
        } else {
            self.hideError()
        }

        if state.isLoading {
            self.showLoading()
        } else {
            self.hideLoading()
        }

        switch state {
        case .success(let models):
            switch models.0 {
            case .success(let models):
                self.updateCurrentWeatherView(models)
                self.updateCurrentWeatherDetailView(models)

            default: break
            }

            switch models.1 {
            case .success(let models):
                self.update(hourlyWeathers: models.hourlyPredictionItem)
            default: break
            }

            switch models.2 {
            case .success(let models):
                self.update(dailyPredictionItem: models.dailyPredictionItem)
            default: break
            }
        default: break
        }
    }

    func showError(message: String) {
        guard self.alertController == nil else {
            return
        }

        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Try again",
                                                 style: UIAlertActionStyle.default,
                                                 handler: {[weak self] (_) in
                                                    self?.loadViewPublishRelay.accept(())
        }))

        alertController.addAction(UIAlertAction(title: "Skip",
                                                 style: UIAlertActionStyle.default,
                                                 handler: nil))

        self.present(alertController, animated: true, completion: nil)
        self.alertController = alertController
    }

    func hideError() {
        self.alertController?.dismiss(animated: true, completion: nil)
    }

    func showLoading() {
        if let loadingView = loadingView {
            loadingView.removeFromSuperview()
        }

        self.loadingView = ViewUtils.showLoadingIndicator(onView: self.view)
    }

    func hideLoading() {
        if let loadingView = loadingView {
            loadingView.removeFromSuperview()
        }
    }
}

extension HomeViewController : PlaceSearchControllerDelegate {
    func placeSearchController(sender: PlaceSearchController, didSelectItem: CityModel) {
        Configuration.sharedInstance.location = LocationFilters(city: didSelectItem, location: nil)
        let location = Configuration.sharedInstance.location
        self.locationFiltersPublishRelay.accept(location)
        UIView.animate(withDuration: 0.25) {
            sender.searchController.isActive = false
            sender.dismiss(animated: true, completion: nil)
        }
    }
}
