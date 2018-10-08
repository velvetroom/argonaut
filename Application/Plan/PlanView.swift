import CleanArchitecture
import MapKit

class PlanView:View<PlanPresenter>, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    private weak var map:PlanMapView!
    private weak var type:PlanTypeView!
    private weak var results:UIScrollView!
    private weak var search:UISearchBar!
    private weak var field:UITextField!
    private weak var searchWidth:NSLayoutConstraint!
    private weak var resultsHeight:NSLayoutConstraint!
    private weak var typeCenter:NSLayoutConstraint!
    private var completer:NSObject!
    override var preferredStatusBarStyle:UIStatusBarStyle { return .lightContent }
    
    @available(iOS 9.3, *)
    func completerDidUpdateResults(_ completer:MKLocalSearchCompleter) {
        presenter.update(results:completer.results)
    }
    
    func searchBar(_:UISearchBar, textDidChange text:String) {
        if #available(iOS 9.3, *) {
            (completer as! MKLocalSearchCompleter).queryFragment = text
        }
    }
    
    func searchBarTextDidBeginEditing(_:UISearchBar) {
        searchWidth.constant = 270
        typeCenter.constant = 145
        UIView.animate(withDuration:0.4, animations: { [weak self] in
            self?.field.backgroundColor = .midnightBlue
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
            UIView.animate(withDuration:0.3) { [weak self] in
                self?.field.backgroundColor = .clear
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_:UISearchBar) {
        search.text = String()
        search.resignFirstResponder()
        if #available(iOS 9.3, *) {
            (completer as! MKLocalSearchCompleter).cancel()
            presenter.update(results:[])
        }
    }
    
    func searchBarSearchButtonClicked(_:UISearchBar) {
        search.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        makeOutlets()
        if #available(iOS 9.3, *) {
            presenter.viewModel { [weak self] viewModel in self?.update(viewModel:viewModel) }
        }
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        map.location.startUpdatingHeading()
        map.location.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
        map.location.stopUpdatingHeading()
        map.location.stopUpdatingLocation()
    }
    
    private func makeOutlets() {
        let map = PlanMapView()
        view.addSubview(map)
        self.map = map
        
        let type = PlanTypeView()
        type.map = map
        view.addSubview(type)
        self.type = type
        
        let cancel = Button(#imageLiteral(resourceName: "iconCancel.pdf"))
        cancel.addTarget(presenter, action:#selector(presenter.cancel), for:.touchUpInside)
        let centre = Button(#imageLiteral(resourceName: "iconCentre.pdf"))
        centre.addTarget(map, action:#selector(map.centreUser), for:.touchUpInside)
        let add = Button(#imageLiteral(resourceName: "iconAdd.pdf"))
        add.addTarget(map, action:#selector(map.addPoint), for:.touchUpInside)
        let save = Button(#imageLiteral(resourceName: "iconSave"))
        save.addTarget(self, action:#selector(make), for:.touchUpInside)
        let bar = Bar(String(), left:[cancel], right:[save, add, centre])
        view.addSubview(bar)
        
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.backgroundColor = .clear
        search.searchBarStyle = .prominent
        search.barStyle = .black
        search.barTintColor = .clear
        search.tintColor = .white
        search.autocorrectionType = .yes
        search.autocapitalizationType = .sentences
        search.spellCheckingType = .yes
        search.keyboardType = .asciiCapable
        search.keyboardAppearance = .dark
        search.delegate = self
        view.addSubview(search)
        self.search = search
        
        field = (search.subviews.first!.subviews.first { view in view is UITextField }) as? UITextField
        field.textColor = .white
        
        let magnifier =  field.leftView as! UIImageView
        magnifier.image = magnifier.image!.withRenderingMode(.alwaysTemplate)
        magnifier.tintColor = .white
        
        let trip = UILabel()
        trip.translatesAutoresizingMaskIntoConstraints = false
        trip.isUserInteractionEnabled = false
        trip.font = .systemFont(ofSize:13, weight:.light)
        trip.textColor = .white
        trip.numberOfLines = 2
        view.addSubview(trip)
        map.trip = trip
        
        let results = UIScrollView()
        results.backgroundColor = .clear
        results.alwaysBounceVertical = true
        results.alwaysBounceHorizontal = false
        results.showsHorizontalScrollIndicator = false
        results.showsVerticalScrollIndicator = true
        results.translatesAutoresizingMaskIntoConstraints = false
        results.indicatorStyle = .white
        view.addSubview(results)
        self.results = results
        
        map.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        map.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        map.topAnchor.constraint(equalTo:results.bottomAnchor, constant:10).isActive = true
        
        type.topAnchor.constraint(equalTo:bar.bottomAnchor, constant:10).isActive = true
        typeCenter = type.centerXAnchor.constraint(equalTo:view.centerXAnchor)
        typeCenter.isActive = true
        
        search.centerYAnchor.constraint(equalTo:type.centerYAnchor).isActive = true
        search.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        search.heightAnchor.constraint(equalToConstant:32).isActive = true
        searchWidth = search.widthAnchor.constraint(equalToConstant:49)
        searchWidth.isActive = true
        
        trip.topAnchor.constraint(equalTo:bar.topAnchor, constant:26).isActive = true
        trip.bottomAnchor.constraint(equalTo:bar.bottomAnchor).isActive = true
        trip.leftAnchor.constraint(equalTo:cancel.rightAnchor).isActive = true
        trip.rightAnchor.constraint(equalTo:centre.leftAnchor).isActive = true
        
        results.topAnchor.constraint(equalTo:type.bottomAnchor, constant:10).isActive = true
        results.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        results.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        resultsHeight = results.heightAnchor.constraint(equalToConstant:0)
        resultsHeight.isActive = true
        
        bar.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        bar.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            completer = MKLocalSearchCompleter()
            (completer as! MKLocalSearchCompleter).delegate = self
        }
    }
    
    @available(iOS 9.3, *)
    private func update(viewModel:[(NSAttributedString, MKLocalSearchCompletion)]) {
        results.subviews.forEach { view in view.removeFromSuperview() }
        let width = results.bounds.width
        let height:CGFloat = viewModel.reduce(into:0) { top, item in
            let view = PlanResultView(frame:CGRect(x:0, y:top, width:width, height:45))
            view.configure(text:item.0)
            view.item = item.1
            view.addTarget(self, action:#selector(selected(view:)), for:.touchUpInside)
            results.addSubview(view)
            top += view.bounds.height
        }
        view.layoutIfNeeded()
        results.contentSize = CGSize(width:width, height:height)
        resultsHeight.constant = min(height, 152)
        UIView.animate(withDuration:0.3) { [weak self] in self?.view.layoutIfNeeded() }
    }
    
    @objc private func selected(view:PlanResultView) {
        search.text = String()
        search.resignFirstResponder()
        if #available(iOS 9.3, *) {
            map.selected(view:view)
            presenter.update(results:[])
        }
    }
    
    @objc private func make() {
        presenter.make(plan:map.plan, route:map.line)
    }
}
