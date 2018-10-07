import MapKit

struct Shot {
    let tileX:Int
    let tileY:Int
    let zoom:Zoom
    
    func options() -> MKMapSnapshotter.Options {
        let options = MKMapSnapshotter.Options()
        let size = zoom.tile * 10
        options.size = CGSize(width:2560, height:2560)
        options.scale = 1
        options.mapRect = MKMapRect(x:Double(tileX) * zoom.tile, y:Double(tileY) * zoom.tile, width:size, height:size)
        return options
    }
}
