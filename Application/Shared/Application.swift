import UIKit

@UIApplicationMain class Application:UIResponder, UIApplicationDelegate {
    var window:UIWindow?
    static let navigation = Navigation()
    
    func application(_:UIApplication, didFinishLaunchingWithOptions:[UIApplication.LaunchOptionsKey:Any]?) -> Bool {
        window = UIWindow(frame:UIScreen.main.bounds)
        window!.backgroundColor = .black
        window!.makeKeyAndVisible()
        window!.rootViewController = Application.navigation
        return true
    }
}