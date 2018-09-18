import MapKit

struct Shot {
    let tileX:Int
    let tileY:Int
    let zoom:Zoom
    
    func options() -> MKMapSnapshotter.Options {
        let options = MKMapSnapshotter.Options()
        options.size = CGSize(width:2560, height:2560)
        options.mapRect = MKMapRect(
            x:Double(tileX) * zoom.size, y:Double(tileY) * zoom.size, width:zoom.size, height:zoom.size)
        return options
    }
}
