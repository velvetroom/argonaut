import Foundation

struct Zoom {
    let level:Int
    let tile:Double
    
    init(level:Int) {
        self.level = level
        self.tile = ceil(1 / (Double(1 << level) / 1048575)) * 256
    }
}
