import Foundation
import Swinject

class DependencyInjection {

    static let sharedInstance = DependencyInjection()

    fileprivate let container: Container
    init() {
        container = Container(parent: nil)
    }

    @discardableResult
    public func register<Service>(
        _ serviceType: Service.Type,
        factory: @escaping () -> Service
        ) -> ServiceEntry<Service> {

        return container.register(serviceType, factory: { (_) -> Service in
            return factory()
        })
    }

    public func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType, name: nil)
    }
}
