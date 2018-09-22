import CleanArchitecture
import MapKit

class PlanView:View<PlanPresenter>, UISearchResultsUpdating, UISearchBarDelegate, MKMapViewDelegate,
CLLocationManagerDelegate {
    private weak var map:MapView!
    private var line:MKRoute?
    private var plan = [MKAnnotation]()
    private let geocoder = CLGeocoder()
    private let location = CLLocationManager()
    
    func mapView(_:MKMapView, viewFor annotation:MKAnnotation) -> MKAnnotationView? {
        guard let mark = annotation as? MKPointAnnotation else { return map.view(for:annotation) }
        var point:MKAnnotationView!
        if let reuse = map.dequeueReusableAnnotationView(withIdentifier:"mark") {
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
        region.span = map.region.span
        region.center = locations.last!.coordinate
        map.setRegion(region, animated:false)
        plan.append(map.userLocation)
    }
    
    func updateSearchResults(for search:UISearchController) {
//        guard
//            let text = search.searchBar.text,
//            !text.isEmpty
//            else {
//                presenter.clearSearch()
//                return
//        }
//        presenter.search(text:text)
    }
    
    func searchBarCancelButtonClicked(_ bar:UISearchBar) {
//        bar.setShowsCancelButton(false, animated:true)
//        presenter.clearSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = NSLocalizedString("PlanView.title", comment:String())
        makeOutlets()
        startLocation()
    }
    
    private func makeOutlets() {
        let map = MapView()
        map.delegate = self
        view.addSubview(map)
        self.map = map
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem:.save, target:self, action:#selector(save)),
            UIBarButtonItem(barButtonSystemItem:.add, target:self, action:#selector(addPoint))]
        
        map.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        map.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            let search = UISearchController(searchResultsController:nil)
            search.searchResultsUpdater = self
            search.searchBar.tintColor = .white
            search.searchBar.barStyle = .black
            search.isActive = true
            search.obscuresBackgroundDuringPresentation = false
            search.hidesNavigationBarDuringPresentation = false
            search.searchBar.delegate = self
            search.searchBar.keyboardAppearance = .dark
            search.searchBar.autocorrectionType = .yes
            search.searchBar.spellCheckingType = .yes
            search.searchBar.autocapitalizationType = .sentences
            navigationItem.searchController = search
            navigationItem.largeTitleDisplayMode = .always
            map.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            map.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        }
    }
    
    private func startLocation() {
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        location.distanceFilter = 100
        location.startUpdatingLocation()
        var region = MKCoordinateRegion()
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        map.setRegion(region, animated:false)
    }
    
    private func geocode(mark:MKPointAnnotation) {
        let location = CLLocation(latitude:mark.coordinate.latitude, longitude:mark.coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { [weak self, weak mark] marks, _ in
            mark?.title = marks?.first?.name
            self?.updateRoute()
        }
    }
    
    private func updateRoute() {
        if let polyline = line?.polyline { map.removeOverlay(polyline) }
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark:MKPlacemark(coordinate:plan.first!.coordinate, addressDictionary:nil))
        request.destination = MKMapItem(placemark:MKPlacemark(coordinate:plan.last!.coordinate, addressDictionary:nil))
        MKDirections(request:request).calculate { [weak self] response, _ in
            guard let line = response?.routes.first else { return }
            self?.line = line
            self?.map.addOverlay(line.polyline, level:.aboveLabels)
        }
    }
    
    @objc private func addPoint() {
        var mark:MKPointAnnotation!
        if plan.first is MKUserLocation && plan.count == 2 { plan.remove(at:0) }
        if plan.count == 2 {
            mark = plan.last as? MKPointAnnotation
        } else {
            mark = MKPointAnnotation()
            plan.append(mark)
            map.addAnnotation(mark)
        }
        mark.coordinate = map.convert(CGPoint(x:map.bounds.midX, y:map.bounds.midY), toCoordinateFrom:map)
        geocode(mark:mark)
    }
    
    @objc private func save() {
        presenter.save(rect:map.visibleMapRect)
    }
}
