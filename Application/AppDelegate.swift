import UIKit
import Domain

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.initDependencyInjection()

        self.window = UIWindow(frame: UIScreen.main.bounds)

        let defaultLocation = Configuration.sharedInstance.location
        let homeController = HomeViewController(viewModel: HomeViewModel(localtionFilters: defaultLocation))

        self.window?.rootViewController = UINavigationController(rootViewController: homeController)
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}
