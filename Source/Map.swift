import MapKit

public class Map {
    let path = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)[0].appendingPathComponent("map")
    var success:((URL) -> Void)?
    var error:((Error) -> Void)?
    private weak var shooter:MKMapSnapshotter?
    private let queue = DispatchQueue(label:String(), qos:.background, target:.global(qos:.background))
    private static let pixelsCoord = 1048575.0
    private static let zoom10 = Double(1 << 10) / pixelsCoord
//    private static let zoom12 = Double(1 << 12) / pixelsCoord
//    private static let zoom14 = Double(1 << 14) / pixelsCoord
//    private static let zoom17 = Double(1 << 17) / pixelsCoord
    private static let imageSize = 2560.0
    
    public init() { }
    
    public func makeMap(rect:MKMapRect) {
        queue.async { [weak self] in
            guard
                let shots = self?.makeShots(rect:rect)
            else { return }
            self?.makeMap(url:URL(string:"google.com")!, shots:shots)
        }
    }
    
    public func acreate(rect:MKMapRect, success:@escaping(UIImage) -> Void, fail:@escaping(Error) -> Void) {
//        let url = directory.appendingPathComponent("a")
        let options = MKMapSnapshotter.Options()
        let pixelX = Map.zoom10 * rect.minX
        let pixelY = Map.zoom10 * rect.minY
        let pixelWidth = (Map.zoom10 * rect.maxX) - options.mapRect.origin.x
        let pixelHeight = (Map.zoom10 * rect.maxY) - options.mapRect.origin.y
        
        let tilesHorizontal = ceil(rect.width * Map.zoom10) / 5
        let tilesVertical = ceil(rect.height * Map.zoom10) / 5
        print("ho \(tilesHorizontal) ve \(tilesVertical)")
        
        options.mapRect = rect
        options.mapRect.size.width = rect.width / tilesHorizontal
        options.mapRect.size.height = rect.height / tilesVertical
        options.size = CGSize(width:Map.imageSize, height:Map.imageSize)
        
        print(options.mapRect)
        
        MKMapSnapshotter(options:options).start(with:queue) { snapshot, error in
            DispatchQueue.main.async {
                guard let image = snapshot?.image
                else { return fail(error == nil ? Exception.mapUnknownError : error!) }
                success(image)
            }
        }
//        try! FileManager.default.createDirectory(at:url, withIntermediateDirectories:true)
//        success(url)
    }
    
    func makeUrl() -> URL {
        let url = path.appendingPathComponent(UUID().uuidString)
        try! FileManager.default.createDirectory(at:url, withIntermediateDirectories:true)
        return url
    }
    
    func makeShots(rect:MKMapRect) -> [Shot] {
        var list = [Shot]()
        list.append(contentsOf:makeShots(rect:rect, zoom:10))
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
        //guard let shot = shots.first else { success(url) }
    }
    
    private func makeShots(rect:MKMapRect, zoom:Int) -> [Shot] {
        let pixels = pixelsFor(zoom:zoom)
        let horizontal = Int(ceil(rect.width / pixels))
        let vertical = Int(ceil(rect.height / pixels))
        var list = [Shot]()
        let startX = Int(rect.minX / pixels)
        let startY = Int(rect.minY / pixels)
        for h in 0 ..< horizontal {
            let tileX = h + startX
            let mapX = Double(tileX) * pixels
            for v in 0 ..< vertical {
                let tileY = v + startY
                let mapY = Double(tileY) * pixels
                list.append(Shot(mapX:mapX, mapY:mapY, tileX:tileX, tileY:tileY, tileZ:zoom))
            }
        }
        return list
    }
    
    private func pixelsFor(zoom:Int) -> Double { return ceil(1 / (Double(1 << zoom) / Map.pixelsCoord)) }
}
