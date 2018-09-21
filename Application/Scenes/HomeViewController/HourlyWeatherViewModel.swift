import UIKit
import RxSwift
import RxCocoa
import Domain

class HourlyWeatherViewModel : ViewModelType {

    enum State {
        case `default`
        case empty
        case loading
        case success(models: TodayWeatherResult)
        case error(error: Error)

        var isLoading: Bool {
            switch self {
            case .loading:
                return true
            default:
                return false
            }
        }

        var isError: Bool {
            switch self {
            case .error:
                return true
            default:
                return false
            }
        }
    }

    struct Input {
        let loadView: Driver<Void>
        let locationFiltersChange: Driver<LocationFilters>
    }

    struct Output {
        let stateDriver: Driver<State>

    }
    let locationFiltersBehaviorRelay: BehaviorRelay<LocationFilters>

    var useCase: PredictionUseCaseProtocol {
        return DependencyInjection.sharedInstance.resolve(PredictionUseCaseProtocol.self)!
    }

    var stateDriver: BehaviorRelay<State>
    var disposeBag: DisposeBag

    init(localtionFilters: LocationFilters) {
        self.locationFiltersBehaviorRelay = BehaviorRelay<LocationFilters>(value: localtionFilters)

        self.stateDriver = BehaviorRelay(value: .default)
        self.disposeBag = DisposeBag()
    }

    func transform(input: Input) -> Output {
        input.locationFiltersChange.drive(self.locationFiltersBehaviorRelay).disposed(by: self.disposeBag)
        let stateDriver = Driver<LocationFilters>.merge([
            input.loadView.withLatestFrom(self.locationFiltersBehaviorRelay.asDriver()),
            self.locationFiltersBehaviorRelay.asDriver()
            ])
        .throttle(1)
            .flatMap {[weak self] (locationFilters) -> Driver<State> in
                guard let strongSelf = self else {
                    return Driver.empty()
                }

                return strongSelf.getWeather(locationFilters: locationFilters)
                    .map({ (result) -> State in
                        if let result = result {
                            return State.success(models: result)
                        } else {
                            return State.empty
                        }
                    })
                    .asDriver(onErrorRecover: { (error) -> Driver<State> in
                        return Driver.just(State.error(error: error))
                    })
        }

        return Output(stateDriver: stateDriver)
    }

    func getWeather(locationFilters: LocationFilters) -> Observable<TodayWeatherResult?> {
        return self.useCase.getTodayWeather(location: locationFilters)
    }
}
