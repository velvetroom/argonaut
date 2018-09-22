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
        showsScale = false
        showsTraffic = false
        showsUserLocation = true
        userTrackingMode = .followWithHeading
        layer.cornerRadius = 20
        mapType = .standard
    }
    
    required init?(coder:NSCoder) { return nil }
}
