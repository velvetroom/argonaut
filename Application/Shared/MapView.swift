import MapKit

class MapView:MKMapView {
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        isRotateEnabled = false
        isPitchEnabled = false
        showsBuildings = true
        showsPointsOfInterest = true
        showsCompass = true
        showsScale = true
        showsTraffic = false
        showsUserLocation = true
        userTrackingMode = .follow
        layer.cornerRadius = 20
        if #available(iOS 11.0, *) {
            mapType = .mutedStandard
        } else {
            mapType = .standard
        }
    }
    
    required init?(coder:NSCoder) { return nil }
}
