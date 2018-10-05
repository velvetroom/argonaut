import MapKit

class MapView:MKMapView, MKMapViewDelegate, CLLocationManagerDelegate {
    private let location = CLLocationManager()
    private weak var headingIndicator:UIImageView?
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        isRotateEnabled = false
        isPitchEnabled = false
        showsBuildings = true
        showsPointsOfInterest = true
        showsCompass = true
        showsScale = false
        showsTraffic = false
        showsUserLocation = true
        userTrackingMode = .followWithHeading
        layer.cornerRadius = 20
        mapType = .standard
        delegate = self
        var region = MKCoordinateRegion()
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        setRegion(region, animated:false)
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        location.distanceFilter = 100
        location.startUpdatingLocation()
        location.startUpdatingHeading()
        start()
    }
    
    deinit {
        location.stopUpdatingHeading()
        location.stopUpdatingLocation()
    }
    
    required init?(coder:NSCoder) { return nil }
    func start() { }
    @objc func centreUser() { centre(coordinate:userLocation.coordinate) }
    
    func centre(coordinate:CLLocationCoordinate2D) {
        var region = MKCoordinateRegion()
        region.span = self.region.span
        region.center = coordinate
        setRegion(region, animated:true)
    }
    
    func mapView(_:MKMapView, viewFor annotation:MKAnnotation) -> MKAnnotationView? {
        guard let mark = annotation as? MKPointAnnotation else { return view(for:annotation) }
        var point:MKAnnotationView!
        if let reuse = dequeueReusableAnnotationView(withIdentifier:"mark") {
            reuse.annotation = mark
            point = reuse
        } else {
            if #available(iOS 11.0, *) {
                let marker = MKMarkerAnnotationView(annotation:mark, reuseIdentifier:"mark")
                marker.markerTintColor = .black
                marker.animatesWhenAdded = true
                point = marker
            } else {
                let marker = MKPinAnnotationView(annotation:mark, reuseIdentifier:"mark")
                marker.pinTintColor = .black
                marker.animatesDrop = true
                point = marker
            }
        }
        return point
    }
    
    func mapView(_:MKMapView, rendererFor overlay:MKOverlay) -> MKOverlayRenderer {
        if let tiler = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay:tiler)
        } else if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline:polyline)
            renderer.lineWidth = 3
            renderer.strokeColor = .black
            renderer.lineCap = .round
            return renderer
        } else {
            return MKOverlayRenderer()
        }
    }
    
    func locationManager(_:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        centre(coordinate:locations.last!.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy > 0 {
            let heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
            headingIndicator?.transform = CGAffineTransform(rotationAngle:CGFloat((heading / 180) * Double.pi))
        }
    }
    
    func mapView(_:MKMapView, didAdd views:[MKAnnotationView]) {
        if  headingIndicator == nil,
            let user = views.first(where: { view in view.annotation is MKUserLocation }) {
            let headingIndicator = UIImageView(frame:user.bounds)
            headingIndicator.image = #imageLiteral(resourceName: "iconHeading.pdf")
            headingIndicator.clipsToBounds = true
            headingIndicator.contentMode = .center
            self.headingIndicator = headingIndicator
            user.addSubview(headingIndicator)
        }
    }
}
