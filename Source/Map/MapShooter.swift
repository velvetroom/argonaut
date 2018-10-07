import MapKit

class MapShooter:MKMapSnapshotter, Shooter {
    var timeout = 10.0
    private weak var timer:Timer?
    private var success:((UIImage) -> Void)?
    private var fail:((Error) -> Void)?
    required init(shot:Shot) { super.init(options:shot.options()) }
    
    func make(queue:DispatchQueue, success:@escaping((UIImage) -> Void), fail:@escaping((Error) -> Void)) {
        self.success = success
        self.fail = fail
        DispatchQueue.main.async { [weak self] in self?.safeMake(queue:queue) }
    }
    
    private func safeMake(queue:DispatchQueue) {
        timer = Timer.scheduledTimer(timeInterval:timeout, target:self, selector:#selector(timed),
                                     userInfo:nil, repeats:false)
        start(with:queue) { [weak self] snapshot, error in
            if let image = snapshot?.image {
                self?.success?(image)
            } else {
                self?.fail?(error == nil ? Exception.mapUnknownError : error!)
            }
        }
    }
    
    @objc private func timed() {
        timer?.invalidate()
        cancel()
        fail?(Exception.mapTimeout)
    }
}
