import CleanArchitecture

class PlanView:View<PlanPresenter> {
    private weak var map:PlanMapView!
    private weak var segmented:UISegmentedControl!
    private let formatter = DateComponentsFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        makeOutlets()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.minute]
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated:true)
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated:true)
    }
    
    private func makeOutlets() {
        let map = PlanMapView()
        map.startLocation()
        view.addSubview(map)
        self.map = map
        
        let segmented = UISegmentedControl(items:["Car", "Transit", "Walking", "Bycicle"])
        segmented.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmented)
        self.segmented = segmented
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem:.save, target:self, action:#selector(save)),
            UIBarButtonItem(barButtonSystemItem:.add, target:map, action:#selector(map.addPoint))]
        
        map.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        map.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        map.topAnchor.constraint(equalTo:segmented.bottomAnchor).isActive = true
        
        segmented.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            segmented.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            segmented.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        }
    }
    
    private func updateTitle() {
        /*if let line = self.line {
            var string = formatter.string(from:line.expectedTravelTime)!
            if #available(iOS 10.0, *) {
                let distance = MeasurementFormatter()
                distance.unitStyle = .medium
                distance.unitOptions = .naturalScale
                distance.numberFormatter.maximumFractionDigits = 1
                string += " - " + distance.string(from:Measurement(value:line.distance, unit:UnitLength.meters))
            }
            title = string
        } else {
            title = NSLocalizedString("PlanView.title", comment:String())
        }*/
    }
    
    @objc private func save() {
        presenter.save(rect:map.visibleMapRect)
    }
}
