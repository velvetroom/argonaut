import MapKit

public class Map {
    public var onSuccess:((Project) -> Void)?
    public var onFail:((Error) -> Void)?
    public var onProgress:((Float) -> Void)?
    public var onClean:(() -> Void)?
    var builder = Builder()
    var shooterType:Shooter.Type = MapShooter.self
    var zooms = Zoom.zooms(profile:Factory.makeSession().profile())
    var path = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)[0].appendingPathComponent("map")
    let session = Factory.makeSession()
    private weak var shooter:Shooter?
    private let queue = DispatchQueue(label:String(), qos:.background, target:.global(qos:.background))
    
    public init() { }
    public func cleanDisk() { queue.async { self.clean(projects:self.session.profile().projects) } }
    
    public func makeMap(points:[MKAnnotation], route:MKRoute?) {
        queue.async { [weak self] in
            self?.builder = Builder()
            if let coordinates = self?.makeProject(points:points, route:route) {
                self?.makeShots(coordinates:coordinates)
                self?.makeUrl()
                self?.retry()
            }
        }
    }
    
    public func retry() {
        queue.async { [weak self] in
            self?.makeMap()
        }
    }
    
    func makeProject(points:[MKAnnotation], route:MKRoute?) -> [CLLocationCoordinate2D] {
        builder.project.id = UUID().uuidString
        if let name = route?.name { builder.project.name = name }
        if let origin = points.first {
            if let title = origin.title as? String { builder.project.origin.title = title }
            builder.project.origin.point.latitude = origin.coordinate.latitude
            builder.project.origin.point.longitude = origin.coordinate.longitude
        }
        if points.count > 1 {
            if let title = points[1].title as? String { builder.project.destination.title = title }
            builder.project.destination.point.latitude = points[1].coordinate.latitude
            builder.project.destination.point.longitude = points[1].coordinate.longitude
        }
        var coordinates = points.map { $0.coordinate }
        if let route = route {
            let points = route.polyline.points()
            for index in 0 ..< route.polyline.pointCount {
                var point = Point()
                let coordinate = points[index].coordinate
                coordinates.append(coordinate)
                point.latitude = coordinate.latitude
                point.longitude = coordinate.longitude
                builder.project.route.append(point)
            }
            builder.project.distance = route.distance
            builder.project.duration = route.expectedTravelTime
        }
        return coordinates
    }
    
    func makeUrl() {
        builder.url = path.appendingPathComponent(builder.project.id)
        try? FileManager.default.createDirectory(at:builder.url, withIntermediateDirectories:true)
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
    
    func makeTiles(shot:Shot, image:UIImage) {
        for y in 0 ..< Int(image.size.width / 256) {
            for x in 0 ..< Int(image.size.height / 256) {
                let cropped = crop(image:image, rect:CGRect(x:x * 256, y:y * 256, width:256, height:256))
                let location = "\(shot.zoom.level)_\(shot.tileX + x)_\(shot.tileY + y).png"
                try! cropped.pngData()!.write(to:builder.url.appendingPathComponent(location))
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
    
    func makeRect(coordinates:[CLLocationCoordinate2D]) -> MKMapRect {
        var rect = MKMapRect()
        var coordinates = coordinates
        if !coordinates.isEmpty {
            let first = coordinates.removeFirst()
            var top = first.latitude
            var bottom = first.latitude
            var left = first.longitude
            var right = first.longitude
            coordinates.forEach { coordinate in
                top = max(top, coordinate.latitude)
                bottom = min(bottom, coordinate.latitude)
                left = min(left, coordinate.longitude)
                right = max(right, coordinate.longitude)
            }
            top += 0.001
            bottom -= 0.001
            left -= 0.001
            right += 0.001
            let topLeft = MKMapPoint(CLLocationCoordinate2D(latitude:top, longitude:left))
            let bottomRight = MKMapPoint(CLLocationCoordinate2D(latitude:bottom, longitude:right))
            let width = bottomRight.x - topLeft.x
            let height = bottomRight.y - topLeft.y
            rect = MKMapRect(x:topLeft.x, y:topLeft.y, width:width > 0 ? width : 1, height:height > 0 ? height : 1)
        }
        return rect
    }
    
    private func makeShots(coordinates:[CLLocationCoordinate2D]) {
        let rect = makeRect(coordinates:coordinates)
        builder.shots = zooms.flatMap { zoom in makeShots(rect:rect, zoom:zoom) }
    }
    
    private func makeMap() {
        if builder.index < builder.shots.count {
            let shot = builder.shots[builder.index]
            shooterType.init(shot:builder.shots[builder.index]).make(queue:queue, success: { [weak self] image in
                self?.makeTiles(shot:shot, image:image)
                self?.progress()
                self?.builder.index += 1
                self?.makeMap()
            }) { [weak self] error in
                self?.fails(error:error)
            }
        } else {
            save()
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
    
    private func save() {
        session.add(project:builder.project)
        success()
    }
    
    private func clean(projects:[String]) {
        guard let folders = try? FileManager.default.contentsOfDirectory(atPath:path.path) else { return }
        folders.filter { !projects.contains($0) }.forEach { folder in
            try? FileManager.default.removeItem(at:path.appendingPathComponent(folder))
        }
        clean()
    }
    
    private func progress() {
        let value = Float(builder.index + 1) / Float(builder.shots.count)
        DispatchQueue.main.async { [weak self] in self?.onProgress?(value) }
    }
    
    private func success() {
        let project = builder.project
        DispatchQueue.main.async { [weak self] in self?.onSuccess?(project) }
    }
    
    private func fails(error:Error) { DispatchQueue.main.async { [weak self] in self?.onFail?(error) } }
    private func clean() { DispatchQueue.main.async { [weak self] in self?.onClean?() } }
}
