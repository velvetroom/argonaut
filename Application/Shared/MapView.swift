import MapKit

class MapView:MKMapView, MKMapViewDelegate {
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
        if #available(iOS 11.0, *) {
            mapType = .mutedStandard
        } else {
            mapType = .standard
        }
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func mapView(_:MKMapView, rendererFor overlay:MKOverlay) -> MKOverlayRenderer {
        if let tiler = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay:tiler)
        }
        else {
            return MKOverlayRenderer()
        }
    }
}
