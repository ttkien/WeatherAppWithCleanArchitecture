import Foundation
import Domain
import RxSwift
import RxCocoa

class HomeViewModel : ViewModelType {
    typealias Model = (CurrentWeatherViewModel.State, HourlyWeatherViewModel.State, DailyWeatherViewModel.State)
    enum State {
        case `default`
        case loading
        case success(models: Model)

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
            case .success(let models):
                return models.0.isError || models.1.isError || models.2.isError
            default:
                return false
            }
        }

        var errors: [Error] {
            if isError {
                var errors = [Error]()

                switch self {
                case .success(let models):
                    switch models.0 {
                    case .error(let error):
                        errors.append(error)
                    default: break
                    }

                    switch models.1 {
                    case .error(let error):
                        errors.append(error)
                    default: break
                    }

                    switch models.2 {
                    case .error(let error):
                        errors.append(error)
                    default: break
                    }

                default:
                    break
                }
                return errors
            } else {
                return []
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
    var currentWeatherViewModel: CurrentWeatherViewModel
    var hourlyWeatherViewModel: HourlyWeatherViewModel
    var weeklyWeatherViewModel: DailyWeatherViewModel

    init(localtionFilters: LocationFilters) {
        self.locationFiltersBehaviorRelay = BehaviorRelay<LocationFilters>(value: localtionFilters)

        self.stateDriver = BehaviorRelay(value: .loading)
        self.disposeBag = DisposeBag()

        self.currentWeatherViewModel = CurrentWeatherViewModel(localtionFilters: localtionFilters)
        self.hourlyWeatherViewModel = HourlyWeatherViewModel(localtionFilters: localtionFilters)
        self.weeklyWeatherViewModel = DailyWeatherViewModel(localtionFilters: localtionFilters)
    }

    func transform(input: Input) -> Output {
        input.locationFiltersChange.drive(self.locationFiltersBehaviorRelay).disposed(by: self.disposeBag)

        let loadView = input.loadView.do(onNext: {[weak self] () in
            self?.stateDriver.accept(.loading)
        })

        let currentWeatherViewModelOutput = self.currentWeatherViewModel.transform(input: CurrentWeatherViewModel.Input(
            loadView: loadView,
            locationFiltersChange: input.locationFiltersChange))

         let hourlyWeatherViewModelOutput = self.hourlyWeatherViewModel.transform(input: HourlyWeatherViewModel.Input(
            loadView: loadView,
            locationFiltersChange: input.locationFiltersChange))

         let weeklyWeatherViewModelOutput = self.weeklyWeatherViewModel.transform(input: DailyWeatherViewModel.Input(
            loadView: loadView,
            locationFiltersChange: input.locationFiltersChange))

        Driver.zip(currentWeatherViewModelOutput.stateDriver,
                                               hourlyWeatherViewModelOutput.stateDriver,
                                               weeklyWeatherViewModelOutput.stateDriver)
            .map { State.success(models: $0)}.drive(self.stateDriver)
        .disposed(by: self.disposeBag)

        return Output(stateDriver: self.stateDriver.asDriver())
    }

}
