import CleanArchitecture
import MapKit

class PlanView:View<PlanPresenter>, UISearchResultsUpdating, UISearchBarDelegate, CLLocationManagerDelegate {
    private let location = CLLocationManager()
    private weak var map:MapView!
    
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
        view.addSubview(map)
        self.map = map
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem:.save, target:self, action:#selector(save)),
            UIBarButtonItem(barButtonSystemItem:.add, target:self, action:#selector(add))]
        
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
    
    @objc private func save() {
        presenter.save(rect:map.visibleMapRect)
    }
    
    @objc private func add() {
        map.addAnnotation(MKPlacemark(coordinate:map.convert(
            CGPoint(x:map.bounds.midX, y:map.bounds.minY), toCoordinateFrom:nil), addressDictionary:nil))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var region = MKCoordinateRegion()
        region.span = map.region.span
        region.center = locations.last!.coordinate
        map.setRegion(region, animated:false)
    }
}
