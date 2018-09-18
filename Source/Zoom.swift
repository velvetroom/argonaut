import Foundation

struct Zoom {
    let level:Int
    let size:Double
    
    init(level:Int) {
        self.level = level
        self.size = ceil(1 / (Double(1 << level) / 1048575))
    }
}
