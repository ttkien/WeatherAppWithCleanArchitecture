import Foundation
import RxSwift
import CoreLocation

public protocol CityRepositoryProtocol {
    func searchCity(searchText: String) -> Observable<[CityModel]>
    func searchCity(location: CLLocationCoordinate2D) -> Observable<CityModel?>

}
