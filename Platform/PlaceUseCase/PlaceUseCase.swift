import Foundation
import Domain
import RxSwift

public class PlaceUseCase: PlaceUseCaseProtocol {
    let placeRepository: CityRepositoryProtocol

    public init(placeRepository: CityRepositoryProtocol) {
        self.placeRepository = placeRepository
    }

    public func searchCity(searchText: String) -> Observable<[CityModel]> {
        return placeRepository.searchCity(searchText: searchText)
    }
}
