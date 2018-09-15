import CleanArchitecture

class NavigateView:View<NavigatePresenter>, UISearchResultsUpdating, UISearchBarDelegate {
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
        title = NSLocalizedString("NavigateView.title", comment:String())
        makeOutlets()
    }
    
    private func makeOutlets() {
        let map = MapView()
        view.addSubview(map)
        self.map = map
        
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
            navigationItem.searchController = search
            navigationItem.largeTitleDisplayMode = .always
            map.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            map.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        }
    }
}
