import MapKit

public class Map {
    let path = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)[0].appendingPathComponent("map")
    var success:((URL) -> Void)?
    var fail:((Error) -> Void)?
    private weak var shooter:MKMapSnapshotter?
    private let queue = DispatchQueue(label:String(), qos:.background, target:.global(qos:.background))
    private static let pixelsCoord = 1048575.0
    private static let zooms = [Zoom(level:10)]
//    private static let zoom12 = Double(1 << 12) / pixelsCoord
//    private static let zoom14 = Double(1 << 14) / pixelsCoord
//    private static let zoom17 = Double(1 << 17) / pixelsCoord
    private static let imageSize = 2560.0
    
    public init() { }
    
    public func makeMap(rect:MKMapRect) {
        queue.async { self.makeMap(url:self.makeUrl(), shots:self.makeShots(rect:rect)) }
    }
    
    func makeUrl() -> URL {
        let url = path.appendingPathComponent(UUID().uuidString)
        try! FileManager.default.createDirectory(at:url, withIntermediateDirectories:true)
        return url
    }
    
    func makeShots(rect:MKMapRect) -> [Shot] {
        var list = [Shot]()
        Map.zooms.forEach { zoom in list.append(contentsOf:makeShots(rect:rect, zoom:zoom)) }
        return list
    }
    
    func makeTiles(image:UIImage) -> [UIImage] {
        var width:Double = 0
        var height:Double = 0
        return []
    }
    
    func crop(image:UIImage, rect:CGRect) -> UIImage {
        let w = CGFloat(image.cgImage!.width)
        let h = CGFloat(image.cgImage!.height)
        UIGraphicsBeginImageContext(rect.size)
        UIGraphicsGetCurrentContext()!.translateBy(x:0, y:rect.height)
        UIGraphicsGetCurrentContext()!.scaleBy(x:1, y:-1)
        UIGraphicsGetCurrentContext()!.draw(image.cgImage!, in:CGRect(x:-rect.minX, y:rect.maxY - h, width:w, height:h))
        let cropped = UIImage(cgImage:UIGraphicsGetCurrentContext()!.makeImage()!)
        UIGraphicsEndImageContext()
        return cropped
    }
    
    private func makeMap(url:URL, shots:[Shot]) {
        guard let shot = shots.first else { return succedes(url:url) }
        MKMapSnapshotter(options:shot.options()).start(with:queue) { [weak self] snapshot, error in
            if let image = snapshot?.image {
                self?.makeMap(url:url, shots:Array(shots.suffix(from:1)))
                return
            }
            self?.failes(error:error == nil ? Exception.mapUnknownError : error!)
        }
    }
    
    private func makeShots(rect:MKMapRect, zoom:Zoom) -> [Shot] {
        let horizontal = Int(ceil(rect.width / zoom.size))
        let vertical = Int(ceil(rect.height / zoom.size))
        var list = [Shot]()
        for h in 0 ..< horizontal {
            for v in 0 ..< vertical {
                list.append(Shot(tileX:h + Int(rect.minX / zoom.size), tileY:v + Int(rect.minY / zoom.size), zoom:zoom))
            }
        }
        return list
    }
    
    private func succedes(url:URL) { DispatchQueue.main.async { [weak self] in self?.success?(url) } }
    private func failes(error:Error) { DispatchQueue.main.async { [weak self] in self?.fail?(error) } }
}
