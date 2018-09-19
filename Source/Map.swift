import MapKit

public class Map {
    public var onSuccess:((URL) -> Void)?
    public var onFail:((Error) -> Void)?
    var shooterType:Shooter.Type = MapShooter.self
    let path = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)[0].appendingPathComponent("map")
    private weak var shooter:Shooter?
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
    
    func makeTiles(url:URL, shot:Shot, image:UIImage) {
        for y in 0 ..< 10 {
            for x in 0 ..< 10 {
                let cropped = crop(image:image, rect:CGRect(x:x, y:y, width:256, height:256))
                let location = "\(shot.zoom.level).\(shot.tileX + x).\(shot.tileY + y)"
                print("writing to: \(url.appendingPathComponent(location))")
                try! cropped.pngData()?.write(to:url.appendingPathComponent(location))
            }
        }
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
        guard let shot = shots.first else { return success(url:url) }
        shooterType.init(shot:shot).make(queue:queue, success: { [weak self] image in
            self?.makeTiles(url:url, shot:shot, image:image)
            self?.makeMap(url:url, shots:Array(shots.suffix(from:1)))
        }) { [weak self] error in self?.fails(error:error) }
    }
    
    private func makeShots(rect:MKMapRect, zoom:Zoom) -> [Shot] {
        let horizontal = Int(ceil(rect.width / zoom.size))
        let vertical = Int(ceil(rect.height / zoom.size))
        var list = [Shot]()
        for h in stride(from:0, to:horizontal, by:10) {
            for v in stride(from:0, to:vertical, by:10) {
                print("tilex: \(h + Int(rect.minX / zoom.size))")
                list.append(Shot(tileX:h + Int(rect.minX / zoom.size), tileY:v + Int(rect.minY / zoom.size), zoom:zoom))
            }
        }
        return list
    }
    
    private func success(url:URL) { DispatchQueue.main.async { [weak self] in self?.onSuccess?(url) } }
    private func fails(error:Error) { DispatchQueue.main.async { [weak self] in self?.onFail?(error) } }
}
