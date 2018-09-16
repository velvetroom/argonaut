import CleanArchitecture

class PlanView:View<PlanPresenter>, UISearchResultsUpdating, UISearchBarDelegate {
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
    
    @objc private func save() {
        print("rect: \(map.visibleMapRect)")
        presenter.save(rect:map.visibleMapRect)
    }
    
    @objc private func add() {
        
    }
}
