import MapKit

public class Map {
    let path = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)[0].appendingPathComponent("map")
    private weak var shooter:MKMapSnapshotter?
    private let queue = DispatchQueue(label:String(), qos:.background, target:.global(qos:.background))
    private static let pixelsCoord = 1048575.0
    private static let zoom10 = Double(1 << 10) / pixelsCoord
//    private static let zoom12 = Double(1 << 12) / pixelsCoord
//    private static let zoom14 = Double(1 << 14) / pixelsCoord
//    private static let zoom17 = Double(1 << 17) / pixelsCoord
    private static let imageSize = 2560.0
    
    public init() { }
    
    public func create(rect:MKMapRect, success:@escaping(UIImage) -> Void, fail:@escaping(Error) -> Void) {
        DispatchQueue.main.async { success(UIImage()) }
        queue.async { [weak self] in
            
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
    
    func shots(rect:MKMapRect) -> [Shot] {
        var list = [Shot]()
        list.append(contentsOf:shots(rect:rect, zoom:10))
        return list
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
    
    private func shots(rect:MKMapRect, zoom:Int) -> [Shot] {
        let pixels = Double(1 << zoom) / Map.pixelsCoord
        let horizontal = Int(rect.width * pixels)
        let vertical = Int(rect.height * pixels)
        var list = [Shot]()
        for h in 0 ..< horizontal {
            
            for v in 0 ..< vertical {
                
            }
        }
        list.append(Shot(mapX:0, mapY:0, tileX:0, tileY:0, tileZ:zoom))
        return list
    }
}
/*

open var mapRect: MKMapRect

open var region: MKCoordinateRegion

open var mapType: MKMapType


open var showsPointsOfInterest: Bool

open var showsBuildings: Bool


open var size: CGSize


open var scale: CGFloat
*/
