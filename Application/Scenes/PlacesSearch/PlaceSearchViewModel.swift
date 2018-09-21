import UIKit
import RxSwift
import RxCocoa
import Domain

class PlaceSearchViewModel : ViewModelType {

    enum State {
        case `default`
        case empty
        case loading
        case success(models:[CityModel])
        case error(error: Error)

        var isLoading: Bool {
            switch self {
            case .loading:
                return true
            default:
                return false
            }
        }
    }

    struct Input {
        let searchText: Driver<String?>
    }

    struct Output {
        let stateDriver: Driver<State>

    }

    var placesUseCase: PlaceUseCaseProtocol {
        return DependencyInjection.sharedInstance.resolve(PlaceUseCaseProtocol.self)!
    }

    var stateDriver: BehaviorRelay<State>
    var disposeBag: DisposeBag

    init() {
        self.stateDriver = BehaviorRelay(value: .default)
        self.disposeBag = DisposeBag()
    }

    func transform(input: Input) -> Output {
        input.searchText
            .do(onNext: {[weak self] (_) in
                self?.stateDriver.accept(PlaceSearchViewModel.State.loading)
            })
            .throttle(2, latest: true)
            .flatMapLatest {[weak self] (searchText) -> Driver<State> in
            guard let strongSelf = self else {
                return Driver.empty()
            }

            return strongSelf.searchPlace(searchText: searchText)
                .map { State.success(models: $0) }
                .asDriver(onErrorRecover: { (error) -> Driver<State> in
                    return Driver.just(State.error(error: error))
            })
        }.drive(self.stateDriver)
            .disposed(by: self.disposeBag)

        return Output(stateDriver: self.stateDriver.asDriver())
    }

    func searchPlace(searchText: String?) -> Observable<[CityModel]> {
        guard let searchText = searchText,
            searchText.isEmpty == false else {
            return Observable.just([])
        }
        return self.placesUseCase.searchCity(searchText: searchText)
    }
}
