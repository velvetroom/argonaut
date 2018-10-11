import Foundation

class Widget:Codable {
    var origin = WidgetMark()
    var destination = WidgetMark()
    
    class func load() -> Widget? {
        if let data = UserDefaults(suiteName:"group.Argonaut")?.data(forKey:"widget") {
            return try? JSONDecoder().decode(Widget.self, from:data)
        }
        return nil
    }
    
    class func remove() {
        let store = UserDefaults(suiteName:"group.Argonaut")
        store?.removeObject(forKey:"widget")
        store?.synchronize()
    }
    
    func store() {
        let store = UserDefaults(suiteName:"group.Argonaut")
        store?.set(try? JSONEncoder().encode(self), forKey:"widget")
        store?.synchronize()
    }
}
