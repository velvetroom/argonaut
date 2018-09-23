import MapKit

public class Map {
    public var onSuccess:((URL) -> Void)?
    public var onFail:((Error) -> Void)?
    var shooterType:Shooter.Type = MapShooter.self
    var zooms = [Zoom(level:16), Zoom(level:18)]
    var path = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)[0].appendingPathComponent("map")
    private weak var shooter:Shooter?
    private let queue = DispatchQueue(label:String(), qos:.background, target:.global(qos:.background))
    
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
        zooms.forEach { zoom in list.append(contentsOf:makeShots(rect:rect, zoom:zoom)) }
        return list
    }
    
    func makeTiles(url:URL, shot:Shot, image:UIImage) {
        for y in 0 ..< Int(image.size.width / 256) {
            for x in 0 ..< Int(image.size.height / 256) {
                let cropped = crop(image:image, rect:CGRect(x:x * 512, y:y * 512, width:512, height:512))
                let location = "\(shot.zoom.level)_\(shot.tileX + x)_\(shot.tileY + y).png"
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
        var list = [Shot]()
        for h in strideIn(start:rect.minX, size:rect.width, tile:zoom.tile) {
            for v in strideIn(start:rect.minY, size:rect.height, tile:zoom.tile) {
                list.append(Shot(tileX:h, tileY:v, zoom:zoom))
            }
        }
        return list
    }
    
    private func strideIn(start:Double, size:Double, tile:Double) -> StrideTo<Int> {
        var start = Int(start / tile)
        let size = Int(ceil(size / tile))
        let delta = (10 - size) / 2
        if delta > 0 {
            start = max(0, start - delta)
        }
        return stride(from:start, to:start + size, by:10)
    }
    
    private func success(url:URL) { DispatchQueue.main.async { [weak self] in self?.onSuccess?(url) } }
    private func fails(error:Error) { DispatchQueue.main.async { [weak self] in self?.onFail?(error) } }
}
