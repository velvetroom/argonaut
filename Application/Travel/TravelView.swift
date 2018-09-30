import CleanArchitecture

class TravelView:View<TravelPresenter> {
    let tiler = TravelTiler()
    private weak var map:MapView!
    override var preferredStatusBarStyle:UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        let map = MapView()
        map.addOverlay(tiler, level:.aboveLabels)
        self.map = map
        view.addSubview(map)
        
        map.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        map.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        map.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
    }
}
