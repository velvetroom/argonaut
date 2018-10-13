import CleanArchitecture
import MapKit

class TravelView:View<TravelPresenter> {
    weak var homePresenter:HomePresenter?
    var homeItem:HomeItem?
    private weak var map:MapView!
    private let tiler = TravelTiler()
    override var preferredStatusBarStyle:UIStatusBarStyle { return .lightContent }
    override var previewActionItems:[UIPreviewActionItem] { return [
        UIPreviewAction(title:.local("TravelView.delete"), style:.destructive) { [weak self] _, _ in
            guard let item = self?.homeItem else { return }
            self?.homePresenter?.delete(item:item)
        }]
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        tiler.url.appendPathComponent(presenter.project.id)
        makeOutlets()
        configureViewModel()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        map.location.startUpdatingLocation()
        map.location.startUpdatingHeading()
    }
    
    private func makeOutlets() {
        let map = MapView()
        map.addOverlay(tiler, level:.aboveLabels)
        self.map = map
        view.addSubview(map)
        
        let close = Button(#imageLiteral(resourceName: "iconCancel.pdf"))
        close.addTarget(presenter, action:#selector(presenter.close), for:.touchUpInside)
        let centre = Button(#imageLiteral(resourceName: "iconCentre.pdf"))
        centre.addTarget(map, action:#selector(map.centreUser), for:.touchUpInside)
        let bar = Bar(presenter.project.name, left:[close], right:[centre])
        view.addSubview(bar)
        
        map.topAnchor.constraint(equalTo:bar.bottomAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        map.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        map.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        bar.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        bar.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
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
