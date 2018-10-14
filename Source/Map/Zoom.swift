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
    static func zooms(profile:Profile) -> [Zoom] {
        var items = [Zoom]()
        let range = profile.highQuality ? Range(15 ... 20) : Range(16 ... 17)
        for index in range {
            items.append(Zoom(index))
        }
        return items
    }
}
