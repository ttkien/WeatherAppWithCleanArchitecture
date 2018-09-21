import UIKit
import RxSwift
import RxCocoa
import Domain

protocol PlaceSearchControllerDelegate : class {
    func placeSearchController(sender: PlaceSearchController, didSelectItem: CityModel)
}

class PlaceSearchController: UIViewController {
    var viewModel: PlaceSearchViewModel!

    typealias ViewModel = PlaceSearchViewModel
    let searchController = UISearchController(searchResultsController: nil)
    let disposeBag = DisposeBag()
    let models = PublishRelay<[CityModel]>()
    weak var delegate: PlaceSearchControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Enter City"

        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            // Fallback on earlier versions
        }
        searchController.searchBar.placeholder = "Search City"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            self.searchController.hidesNavigationBarDuringPresentation = true

        } else {
            // Fallback on earlier versions
            self.navigationItem.titleView = searchController.searchBar
            self.searchController.hidesNavigationBarDuringPresentation = false

            self.loadViewIfNeeded()
        }
        definesPresentationContext = true

        // Setup the Scope Bar
        searchController.searchBar.delegate = self

        self.bindViewModel()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                 target: self,
                                                                 action: #selector(didSelectButtonDone(sender:)))
    }

    @objc func didSelectButtonDone(sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.searchController.isActive = true
        if animated {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.searchController.searchBar.becomeFirstResponder()

            }
        } else {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PlaceSearchController : BindableType {

    func bindInput() -> PlaceSearchViewModel.Input {
        let searchTextDidChange = self.searchController.searchBar.rx.text.asDriver()
        return PlaceSearchViewModel.Input(searchText: searchTextDidChange)
    }

    func bind(output: PlaceSearchViewModel.Output) {
        output.stateDriver.drive(onNext: {[weak self] (state) in
            self?.update(state: state)
        }).disposed(by: self.disposeBag)

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.models.bind(to: self.tableView.rx.items(cellIdentifier: "Cell")) { _, model, cell in
            cell.textLabel?.text = model.name
            }
            .disposed(by: self.disposeBag)
        self.tableView.rx.modelSelected(CityModel.self)
            .subscribe(onNext: {[weak self](cityModel) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.delegate?.placeSearchController(sender: strongSelf, didSelectItem: cityModel)
            }).disposed(by: self.disposeBag)
    }

    func update(state: ViewModel.State) {

        UIApplication.shared.isNetworkActivityIndicatorVisible = state.isLoading

        switch state {

        case .default:
            break
        case .empty:
            break
        case .loading:
            break
        case .success(let models):
            self.models.accept(models)
        case .error(let error):
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension PlaceSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PlaceSearchController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {

    }
}
