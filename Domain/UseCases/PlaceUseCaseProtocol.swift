import Foundation
import RxSwift

public protocol PlaceUseCaseProtocol {
    func searchCity(searchText: String) -> Observable<[CityModel]>
}
