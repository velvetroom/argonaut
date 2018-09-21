import MapKit

class MapView:MKMapView, MKMapViewDelegate {
    private var route:MKRoute?
    private let geocoder = CLGeocoder()
    
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
        delegate = self
        mapType = .standard
    }
    
    required init?(coder:NSCoder) { return nil }
    
    @objc func newAnnotation() {
        let coordinate = convert(CGPoint(x:bounds.midX, y:bounds.midY), toCoordinateFrom:self)
        let point = MKPointAnnotation()
        point.coordinate = coordinate
        geocode(point:point)
        addAnnotation(point)
        makeRoute()
    }
    
    func mapView(_:MKMapView, viewFor annotation:MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return view(for:annotation) }
        var pin:MKAnnotationView!
        if let reuse = dequeueReusableAnnotationView(withIdentifier:"pin") {
            reuse.annotation = annotation
            pin = reuse
        } else {
            if #available(iOS 11.0, *) {
                let marker = MKMarkerAnnotationView(annotation:annotation, reuseIdentifier:"pin")
                marker.markerTintColor = .black
                marker.animatesWhenAdded = true
                pin = marker
            } else {
                let marker = MKPinAnnotationView(annotation:annotation, reuseIdentifier:"pin")
                marker.pinTintColor = .black
                marker.animatesDrop = true
                pin = marker
            }
            pin.isDraggable = true
        }
        return pin
    }
    
    func mapView(_:MKMapView, rendererFor overlay:MKOverlay) -> MKOverlayRenderer {
        if let tiler = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay:tiler)
        } else if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline:polyline)
            renderer.lineWidth = 2
            renderer.strokeColor = .black
            return renderer
        } else {
            return MKOverlayRenderer()
        }
    }
    
    func mapView(_:MKMapView, annotationView view:MKAnnotationView, didChange state:MKAnnotationView.DragState,
                 fromOldState:MKAnnotationView.DragState) {
        if state == .ending {
            geocode(point:view.annotation as! MKPointAnnotation)
        }
    }
    
    private func makeRoute() {
        if let polyline = route?.polyline { removeOverlay(polyline) }
        if annotations.count > 2 {
            let source = annotations.first { item -> Bool in return !(item is MKUserLocation) }!.coordinate
            let destination = annotations.last!.coordinate
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark:MKPlacemark(coordinate:source, addressDictionary:nil))
            request.destination = MKMapItem(placemark:MKPlacemark(coordinate:destination, addressDictionary:nil))
            MKDirections(request:request).calculate { [weak self] response, _ in
                guard let route = response?.routes.first else { return }
                self?.route = route
                self?.addOverlay(route.polyline, level:.aboveLabels)
            }
        }
    }
    
    private func geocode(point:MKPointAnnotation) {
        let location = CLLocation(latitude:point.coordinate.latitude, longitude:point.coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { [weak point] marks, _ in point?.title = marks?.first?.name }
    }
}
