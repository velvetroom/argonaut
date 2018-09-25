import CleanArchitecture

class PlanView:View<PlanPresenter> {
    private weak var map:PlanMapView!
    private weak var type:PlanTypeView!
    private weak var add:UIButton!
    private weak var save:UIButton!
    private let formatter = DateComponentsFormatter()
    override var preferredStatusBarStyle:UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.minute]
        makeOutlets()
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
        
        let type = PlanTypeView()
        view.addSubview(type)
        self.type = type
        
        let add = UIButton()
        add.setImage(#imageLiteral(resourceName: "iconAdd.pdf"), for:[])
        add.translatesAutoresizingMaskIntoConstraints = false
        add.imageView!.clipsToBounds = true
        add.imageView!.contentMode = .center
        add.addTarget(map, action:#selector(map.addPoint), for:.touchUpInside)
        view.addSubview(add)
        self.add = add
        
        let save = UIButton()
        save.setImage(#imageLiteral(resourceName: "iconSave"), for:[])
        save.translatesAutoresizingMaskIntoConstraints = false
        save.imageView!.clipsToBounds = true
        save.imageView!.contentMode = .center
        save.addTarget(map, action:#selector(map.addPoint), for:.touchUpInside)
        view.addSubview(save)
        self.save = save
        
        map.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        map.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        map.topAnchor.constraint(equalTo:type.bottomAnchor, constant:15).isActive = true
        
        type.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        type.topAnchor.constraint(equalTo:add.bottomAnchor).isActive = true
        
        add.centerYAnchor.constraint(equalTo:save.centerYAnchor).isActive = true
        add.rightAnchor.constraint(equalTo:save.leftAnchor).isActive = true
        add.heightAnchor.constraint(equalToConstant:36).isActive = true
        add.widthAnchor.constraint(equalToConstant:50).isActive = true
        
        save.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        save.heightAnchor.constraint(equalToConstant:36).isActive = true
        save.widthAnchor.constraint(equalToConstant:50).isActive = true
        
        if #available(iOS 11.0, *) {
            save.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            save.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
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
    
//    @objc private func save() {
//        presenter.save(rect:map.visibleMapRect)
//    }
}
