import UIKit
import Argonaut

@UIApplicationMain class Application:UIResponder, UIApplicationDelegate {
    var window:UIWindow?
    static let navigation = Navigation()
    
    func application(_:UIApplication, didFinishLaunchingWithOptions options:[UIApplication.LaunchOptionsKey:
        Any]?) -> Bool {
        Factory.storage = Storage.self
        window = UIWindow(frame:UIScreen.main.bounds)
        window!.backgroundColor = .black
        window!.makeKeyAndVisible()
        window!.rootViewController = Application.navigation
        return launch(options:options)
    }
    
    func application(_:UIApplication, open url:URL, options:[UIApplication.OpenURLOptionsKey:Any] = [:]) -> Bool {
        if let map = try? mapFrom(url:url) {
            Application.navigation.open(map:map)
            return true
        }
        return false
    }
    
    func application(_:UIApplication, performActionFor item:UIApplicationShortcutItem,
                     completionHandler:@escaping(Bool) -> Void) {
        shortcut(item:item)
    }
    
    private func launch(options:[UIApplication.LaunchOptionsKey:Any]?) -> Bool {
        var needsLaunch = false
        if let url = options?[.url] as? URL,
            let map = try? mapFrom(url:url) {
            Application.navigation.open(map:map)
        } else {
            if let item = options?[.shortcutItem] as? UIApplicationShortcutItem {
                shortcut(item:item)
            } else {
                Application.navigation.launchDefault()
                needsLaunch = true
            }
        }
        return needsLaunch
    }
    
    private func shortcut(item:UIApplicationShortcutItem) {
        switch item.type {
        case "argonaut.map":
            if let map = try? mapFrom(item:item) {
                Application.navigation.open(map:map)
            }
        default: break
        }
    }
    
    private func mapFrom(url:URL) throws -> String {
        let components = url.absoluteString.components(separatedBy:"argonaut:map=")
        if components.count == 2,
            !components[1].isEmpty {
            return components[1]
        }
        throw Exception.invalidId
    }
    
    private func mapFrom(item:UIApplicationShortcutItem) throws -> String {
        if let id = item.userInfo?["id"] as? String,
            !id.isEmpty {
            return id
        }
        throw Exception.invalidId
    }
}
