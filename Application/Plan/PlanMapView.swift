import MapKit

class PlanMapView:MapView, MKMapViewDelegate, CLLocationManagerDelegate {
    weak var trip:UILabel!
    var type = MKDirectionsTransportType.walking
    private var line:MKRoute?
    private var plan = [MKAnnotation]()
    private let geocoder = CLGeocoder()
    private let location = CLLocationManager()
    private let formatter = DateComponentsFormatter()
    
    func startLocation() {
        delegate = self
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.minute]
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        location.distanceFilter = 100
        location.startUpdatingLocation()
        var region = MKCoordinateRegion()
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        setRegion(region, animated:false)
    }
    
    func updateRoute() {
        removeOverlays(overlays)
        if plan.count > 1 {
            let request = MKDirections.Request()
            request.transportType = type
            request.source = MKMapItem(placemark:MKPlacemark(coordinate:plan.first!.coordinate, addressDictionary:nil))
            request.destination = MKMapItem(placemark:MKPlacemark(coordinate:plan.last!.coordinate, addressDictionary:nil))
            MKDirections(request:request).calculate { [weak self] response, _ in
                guard let line = response?.routes.first else { return }
                self?.line = line
                self?.addOverlay(line.polyline, level:.aboveLabels)
                self?.updateTitle()
            }
        }
    }
    
    @objc func addPoint() {
        var mark:MKPointAnnotation!
        if plan.first is MKUserLocation && plan.count == 2 { plan.remove(at:0) }
        if plan.count == 2 {
            mark = plan.last as? MKPointAnnotation
        } else {
            mark = MKPointAnnotation()
            plan.append(mark)
            addAnnotation(mark)
        }
        mark.coordinate = convert(CGPoint(x:bounds.midX, y:bounds.midY), toCoordinateFrom:self)
        geocode(mark:mark)
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
            point.isDraggable = true
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
    
    func mapView(_:MKMapView, annotationView view:MKAnnotationView, didChange state:MKAnnotationView.DragState,
                 fromOldState:MKAnnotationView.DragState) {
        if state == .ending {
            geocode(mark:view.annotation as! MKPointAnnotation)
        }
    }
    
    func locationManager(_:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        var region = MKCoordinateRegion()
        region.span = self.region.span
        region.center = locations.last!.coordinate
        setRegion(region, animated:false)
        if plan.isEmpty { plan.append(userLocation) }
    }
    
    private func geocode(mark:MKPointAnnotation) {
        let location = CLLocation(latitude:mark.coordinate.latitude, longitude:mark.coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { [weak self, weak mark] marks, _ in
            mark?.title = marks?.first?.name
            self?.updateRoute()
        }
    }
    
    private func updateTitle() {
        if let line = self.line {
            var string = formatter.string(from:line.expectedTravelTime)!
            if #available(iOS 10.0, *) {
                let distance = MeasurementFormatter()
                distance.unitStyle = .medium
                distance.unitOptions = .naturalScale
                distance.numberFormatter.maximumFractionDigits = 1
                string += " - " + distance.string(from:Measurement(value:line.distance, unit:UnitLength.meters))
            }
            trip.text = string
        } else {
            trip.text = String()
        }
    }
}
