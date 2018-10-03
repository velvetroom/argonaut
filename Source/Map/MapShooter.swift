import MapKit

class MapShooter:MKMapSnapshotter, Shooter {
    required init(shot:Shot) { super.init(options:shot.options()) }
    
    func make(queue:DispatchQueue, success:@escaping((UIImage) -> Void), fail:@escaping((Error) -> Void)) {
        start(with:queue) { snapshot, error in
            if let image = snapshot?.image {
                success(image)
            } else {
                fail(error == nil ? Exception.mapUnknownError : error!)
            }
        }
    }
}
