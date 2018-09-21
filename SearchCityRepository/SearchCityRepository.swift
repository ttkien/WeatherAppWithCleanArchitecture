import Foundation
import Domain
import GooglePlaces
import GoogleMaps
import RxSwift

public class SearchCityRepository :  CityRepositoryProtocol {
    public init() {

    }
    
    public func searchCity(searchText: String) -> Observable<[CityModel]> {
        return Observable.create({ (observer) -> Disposable in
            let disposable = Disposables.create()

            let filter = GMSAutocompleteFilter()
            filter.type = .city
            GMSPlacesClient.shared()
                .autocompleteQuery(searchText,
                                   bounds: GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                                                               coordinate: CLLocationCoordinate2D(latitude: 100, longitude: 100)),
                                   filter: filter) { (autocompletePrediction, error) in

                                    if let error = error {
                                        observer.onError(error)
                                    } else if let autocompletePrediction = autocompletePrediction {
                                        let citys = autocompletePrediction.map({ (prediction) -> CityModel in
                                            return self.tranformGMSAutocompletePredictionToCityModel(automcomplete: prediction)
                                        })

                                        observer.onNext(citys)
                                    } else {
                                        observer.onNext([])
                                    }

                                    disposable.dispose()
            }

            return disposable
        })
    }

    func tranformGMSAutocompletePredictionToCityModel(automcomplete: GMSAutocompletePrediction) -> CityModel {

        let country = automcomplete.attributedFullText.string.components(separatedBy: ",").last ?? ""
        return CityModel(name: automcomplete.attributedPrimaryText.string, country: country)
    }

    public func searchCity(location: CLLocationCoordinate2D) -> Observable<CityModel?> {
        return Observable.create({ (observer) -> Disposable in

            let disposable = Disposables.create()
            GMSGeocoder().reverseGeocodeCoordinate(location) { (geocoderResponse, error) in

                if let error = error {
                    observer.onError(error)
                    
                } else {
                    let city = geocoderResponse.map({ (response) -> CityModel? in
                        self.tranformGeocoderResponseToCityModel(response: response)
                    }) ?? nil

                    observer.onNext(city)
                }
                disposable.dispose()
            }

            return disposable
        })

    }

    func tranformGeocoderResponseToCityModel(response: GMSReverseGeocodeResponse) -> CityModel? {
        if let firstResult = response.firstResult() {
            return CityModel(name: firstResult.locality ?? "", country: firstResult.country ?? "")
        } else {
            return nil
        }
    }

}
