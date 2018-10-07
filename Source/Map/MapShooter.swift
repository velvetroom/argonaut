import MapKit

class MapShooter:MKMapSnapshotter, Shooter {
    var timeout = 7.0
    private weak var timer:Timer?
    private var fail:((Error) -> Void)?
    required init(shot:Shot) { super.init(options:shot.options()) }
    
    func make(queue:DispatchQueue, success:@escaping((UIImage) -> Void), fail:@escaping((Error) -> Void)) {
        self.fail = fail
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval:self.timeout, target:self, selector:#selector(self.timed),
                                              userInfo:nil, repeats:false)
            self.start(with:queue) { [weak self] snapshot, error in
                self?.timer?.invalidate()
                if let image = snapshot?.image {
                    success(image)
                } else {
                    fail(error == nil ? Exception.mapUnknownError : error!)
                }
            }
        }
    }
    
    @objc private func timed() {
        timer?.invalidate()
        cancel()
        fail?(Exception.mapTimeout)
    }
}
