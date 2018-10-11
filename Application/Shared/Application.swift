import UIKit
import Argonaut

@UIApplicationMain class Application:UIResponder, UIApplicationDelegate {
    var window:UIWindow?
    static let navigation = Navigation()
    
    func application(_:UIApplication, didFinishLaunchingWithOptions:[UIApplication.LaunchOptionsKey:Any]?) -> Bool {
        Factory.storage = Storage.self
        window = UIWindow(frame:UIScreen.main.bounds)
        window!.backgroundColor = .black
        window!.makeKeyAndVisible()
        window!.rootViewController = Application.navigation
        return true
    }
    
    func application(_:UIApplication, open url:URL, options:[UIApplication.OpenURLOptionsKey:Any] = [:]) -> Bool {
        if let map = try? mapFrom(url:url) {
            Application.navigation.open(map:map)
            return true
        }
        return false
    }
    
    private func mapFrom(url:URL) throws -> String {
        let components = url.absoluteString.components(separatedBy:"argonaut:map=")
        if components.count == 2,
            !components[1].isEmpty {
            return components[1]
        }
        throw Exception.mapUnknownError
    }
}
