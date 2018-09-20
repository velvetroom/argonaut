import CleanArchitecture
import CoreLocation

class PermissionView:View<PermissionPresenter>, CLLocationManagerDelegate {
    private var manager:CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        makeOutlets()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        checkStatus()
    }
    
    private func makeOutlets() {
        
    }
    
    private func checkStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse, .restricted: presenter.authorized()
        case .denied: presenter.denied()
        case .notDetermined: notDetermined()
        }
    }
    
    private func notDetermined() {
        manager = CLLocationManager()
        manager!.delegate = self
        manager!.requestWhenInUseAuthorization()
    }
    
    func locationManager(_:CLLocationManager, didChangeAuthorization status:CLAuthorizationStatus) {
        if status != .notDetermined {
            checkStatus()
        }
    }
}
