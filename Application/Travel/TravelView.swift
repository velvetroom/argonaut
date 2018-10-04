import CleanArchitecture
import MapKit

class TravelView:View<TravelPresenter> {
    private weak var map:MapView!
    private let tiler = TravelTiler()
    override var preferredStatusBarStyle:UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        tiler.url.appendPathComponent(presenter.project.id.uuidString)
        makeOutlets()
        configureViewModel()
        super.viewDidLoad()
    }
    
    private func makeOutlets() {
        let map = MapView()
        map.addOverlay(tiler, level:.aboveLabels)
        self.map = map
        view.addSubview(map)
        
        map.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        map.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        map.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
    }
    
    private func configureViewModel() {
        presenter.viewModel { [weak self] (viewModel:[MKAnnotation]) in
            viewModel.forEach { annotation in self?.map.addAnnotation(annotation) }
        }
        presenter.viewModel { [weak self] (viewModel:MKPolyline) in
            self?.map.addOverlay(viewModel, level:.aboveLabels)
        }
    }
}
