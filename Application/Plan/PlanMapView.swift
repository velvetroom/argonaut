import MapKit

class PlanMapView:MapView {
    weak var trip:UILabel!
    var type = MKDirectionsTransportType.walking
    private(set) var plan = [MKAnnotation]()
    private(set) var line:MKRoute?
    private let geocoder = CLGeocoder()
    private let formatter = DateComponentsFormatter()
    
    override init() {
        super.init()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.minute, .hour]
    }
    
    required init?(coder:NSCoder) { return nil }
    
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
    
    @objc func addPoint() { add(coordinate:convert(CGPoint(x:bounds.midX, y:bounds.midY), toCoordinateFrom:self)) }
    
    @available(iOS 9.3, *)
    func selected(view:PlanResultView) {
        UIApplication.shared.keyWindow!.endEditing(true)
        let completion = view.item as! MKLocalSearchCompletion
        MKLocalSearch(request:MKLocalSearch.Request(completion:completion)).start { [weak self] response, _ in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else { return }
            self?.add(coordinate:coordinate)
            self?.centre(coordinate:coordinate)
        }
    }
    
    override func mapView(_ map:MKMapView, viewFor annotation:MKAnnotation) -> MKAnnotationView? {
        let view = super.mapView(map, viewFor:annotation)
        view?.isDraggable = true
        return view
    }
    
    func mapView(_:MKMapView, annotationView view:MKAnnotationView, didChange state:MKAnnotationView.DragState,
                 fromOldState:MKAnnotationView.DragState) {
        if state == .ending {
            geocode(mark:view.annotation as! MKPointAnnotation)
            updateDistance(view:view)
        }
    }
    
    override func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        super.locationManager(manager, didUpdateLocations: locations)
        if plan.isEmpty { plan.append(userLocation) }
    }
    
    private func add(coordinate:CLLocationCoordinate2D) {
        var mark:MKPointAnnotation!
        if plan.first is MKUserLocation && plan.count == 2 { plan.remove(at:0) }
        if plan.count == 2 {
            mark = plan.last as? MKPointAnnotation
        } else {
            mark = MKPointAnnotation()
            plan.append(mark)
            addAnnotation(mark)
        }
        mark.coordinate = coordinate
        geocode(mark:mark)
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
                string += "\n" + distance.string(from:Measurement(value:line.distance, unit:UnitLength.meters))
            }
            trip.text = string
        } else {
            trip.text = String()
        }
    }
}
