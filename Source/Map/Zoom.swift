import Foundation

struct Zoom {
    let level:Int
    let tile:Double
    
    init(_ level:Int) {
        self.level = level
        self.tile = ceil(1 / (Double(1 << level) / 1048575)) * 256
    }
}


extension Zoom {
    static func zooms() -> [Zoom] {
        var items = [Zoom]()
        for index in 0 ... 20 {
            items.append(Zoom(index))
        }
        return items
    }
}
