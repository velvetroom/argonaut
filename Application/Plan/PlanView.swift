import CleanArchitecture

class PlanView:View<PlanPresenter>, UISearchBarDelegate {
    private weak var map:PlanMapView!
    private weak var type:PlanTypeView!
    private weak var search:UISearchBar!
    private weak var add:UIButton!
    private weak var save:UIButton!
    private weak var searchWidth:NSLayoutConstraint!
    private weak var typeCenter:NSLayoutConstraint!
    private let formatter = DateComponentsFormatter()
    override var preferredStatusBarStyle:UIStatusBarStyle { return .lightContent }
    
    func searchBarTextDidBeginEditing(_:UISearchBar) {
        searchWidth.constant = 270
        typeCenter.constant = 145
        UIView.animate(withDuration:0.4, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }) { [weak self] _ in
            self?.search.setShowsCancelButton(true, animated:true)
        }
    }
    
    func searchBarTextDidEndEditing(_:UISearchBar) {
        if search.text!.isEmpty {
            searchWidth.constant = 49
            typeCenter.constant = 0
            search.setShowsCancelButton(false, animated:false)
            UIView.animate(withDuration:0.3) { [weak self] in self?.view.layoutIfNeeded() }
        }
    }
    
    func searchBarCancelButtonClicked(_:UISearchBar) {
        search.text = String()
        search.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_:UISearchBar) {
        search.resignFirstResponder()
    }
    
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
    
    private func makeOutlets() {
        let map = PlanMapView()
        map.startLocation()
        view.addSubview(map)
        self.map = map
        
        let type = PlanTypeView()
        type.map = map
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
        
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.backgroundColor = .clear
        search.searchBarStyle = .prominent
        search.barStyle = .black
        search.barTintColor = .clear
        search.tintColor = .white
        search.delegate = self
        view.addSubview(search)
        self.search = search
        
        let field = (search.subviews.first!.subviews.first { view -> Bool in view is UITextField }) as! UITextField
        field.backgroundColor = .midnightBlue
        field.textColor = .white
        
        let magnifier =  field.leftView as! UIImageView
        magnifier.image = magnifier.image!.withRenderingMode(.alwaysTemplate)
        magnifier.tintColor = .white
        
        map.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        map.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        map.topAnchor.constraint(equalTo:type.bottomAnchor, constant:15).isActive = true
        
        type.topAnchor.constraint(equalTo:add.bottomAnchor, constant:10).isActive = true
        typeCenter = type.centerXAnchor.constraint(equalTo:view.centerXAnchor)
        typeCenter.isActive = true
        
        add.centerYAnchor.constraint(equalTo:save.centerYAnchor).isActive = true
        add.rightAnchor.constraint(equalTo:save.leftAnchor).isActive = true
        add.heightAnchor.constraint(equalToConstant:46).isActive = true
        add.widthAnchor.constraint(equalToConstant:52).isActive = true
        
        save.rightAnchor.constraint(equalTo:view.rightAnchor, constant:-5).isActive = true
        save.heightAnchor.constraint(equalToConstant:46).isActive = true
        save.widthAnchor.constraint(equalToConstant:52).isActive = true
        
        search.centerYAnchor.constraint(equalTo:type.centerYAnchor).isActive = true
        search.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        search.heightAnchor.constraint(equalToConstant:32).isActive = true
        searchWidth = search.widthAnchor.constraint(equalToConstant:49)
        searchWidth.isActive = true
        
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
