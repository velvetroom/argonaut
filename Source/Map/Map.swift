import MapKit

public class Map {
    public var onSuccess:((Project) -> Void)?
    public var onFail:((Error) -> Void)?
    public var onProgress:((Float) -> Void)?
    var shooterType:Shooter.Type = MapShooter.self
    var zooms = [Zoom(level:10), Zoom(level:14), Zoom(level:17), Zoom(level:20)]
    var path = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)[0].appendingPathComponent("map")
    let session = Factory.makeSession()
    private weak var shooter:Shooter?
    private let queue = DispatchQueue(label:String(), qos:.background, target:.global(qos:.background))
    public init() { }
    
    public func makeMap(points:[MKAnnotation], route:MKRoute?) {
        queue.async {
            let project = self.makeProject(points:points, route:route)
            let rect = self.makeRect(points:points)
            let shots = self.zooms.flatMap { zoom in self.makeShots(rect:rect, zoom:zoom) }
            self.makeMap(project:project, url:self.makeUrl(project:project), shots:shots, index:0)
        }
    }
    
    func makeProject(points:[MKAnnotation], route:MKRoute?) -> Project {
        let project = Project()
        project.id = UUID().uuidString
        if let origin = points.first {
            if let title = origin.title as? String { project.origin.title = title }
            project.origin.point.latitude = origin.coordinate.latitude
            project.origin.point.longitude = origin.coordinate.longitude
        }
        if points.count > 1 {
            if let title = points[1].title as? String { project.destination.title = title }
            project.destination.point.latitude = points[1].coordinate.latitude
            project.destination.point.longitude = points[1].coordinate.longitude
        }
        if let route = route {
            let points = route.polyline.points()
            for index in 0 ..< route.polyline.pointCount {
                var point = Point()
                point.latitude = points[index].coordinate.latitude
                point.longitude = points[index].coordinate.longitude
                project.route.append(point)
            }
            project.distance = route.distance
            project.duration = route.expectedTravelTime
        }
        return project
    }
    
    func makeUrl(project:Project) -> URL {
        let url = path.appendingPathComponent(project.id)
        try! FileManager.default.createDirectory(at:url, withIntermediateDirectories:true)
        return url
    }
    
    func makeShots(rect:MKMapRect, zoom:Zoom) -> [Shot] {
        var list = [Shot]()
        for h in strideIn(start:rect.minX, size:rect.width, tile:zoom.tile) {
            for v in strideIn(start:rect.minY, size:rect.height, tile:zoom.tile) {
                list.append(Shot(tileX:h, tileY:v, zoom:zoom))
            }
        }
        return list
    }
    
    func makeTiles(url:URL, shot:Shot, image:UIImage) {
        for y in 0 ..< Int(image.size.width / 256) {
            for x in 0 ..< Int(image.size.height / 256) {
                let cropped = crop(image:image, rect:CGRect(x:x * 512, y:y * 512, width:512, height:512))
                let location = "\(shot.zoom.level)_\(shot.tileX + x)_\(shot.tileY + y).png"
                try! cropped.pngData()!.write(to:url.appendingPathComponent(location))
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
    
    func makeRect(points:[MKAnnotation]) -> MKMapRect {
        var rect = MKMapRect()
        var points = points
        if !points.isEmpty {
            let first = points.removeFirst()
            var top = first.coordinate.latitude
            var bottom = first.coordinate.latitude
            var left = first.coordinate.longitude
            var right = first.coordinate.longitude
            points.forEach { point in
                top = max(top, point.coordinate.latitude)
                bottom = min(bottom, point.coordinate.latitude)
                left = min(left, point.coordinate.longitude)
                right = max(right, point.coordinate.longitude)
            }
            let topLeft = MKMapPoint(CLLocationCoordinate2D(latitude:top, longitude:left))
            let bottomRight = MKMapPoint(CLLocationCoordinate2D(latitude:bottom, longitude:right))
            let width = bottomRight.x - topLeft.x
            let height = bottomRight.y - topLeft.y
            rect = MKMapRect(x:topLeft.x, y:topLeft.y, width:width > 0 ? width : 1, height:height > 0 ? height : 1)
        }
        return rect
    }
    
    private func makeMap(project:Project, url:URL, shots:[Shot], index:Int) {
        if index < shots.count {
            shooterType.init(shot:shots[index]).make(queue:queue, success: { [weak self] image in
                self?.progress(value:Float(index + 1) / Float(shots.count))
                self?.makeTiles(url:url, shot:shots[index], image:image)
                self?.makeMap(project:project, url:url, shots:shots, index:index + 1)
            }) { [weak self] error in self?.fails(error:error) }
        } else {
            save(project:project)
        }
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
    
    private func save(project:Project) {
        session.add(project:project)
        success(project:project)
    }
    
    private func success(project:Project) { DispatchQueue.main.async { [weak self] in self?.onSuccess?(project) } }
    private func fails(error:Error) { DispatchQueue.main.async { [weak self] in self?.onFail?(error) } }
    private func progress(value:Float) { DispatchQueue.main.async { [weak self] in self?.onProgress?(value) } }
}
