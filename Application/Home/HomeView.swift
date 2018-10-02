import CleanArchitecture

class HomeView:View<HomePresenter> {
    private weak var scroll:UIScrollView!
    private weak var items:UIView!
    override var preferredStatusBarStyle:UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        makeOutlets()
        configureViewModel()
    }
    
    override func viewWillTransition(to size:CGSize, with coordinator:UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        layoutItems(size:size)
    }
    
    private func makeOutlets() {
        let map = Button(image:#imageLiteral(resourceName: "iconMap.pdf"))
        map.addTarget(presenter, action:#selector(presenter.map), for:.touchUpInside)
        let settings = Button(image:#imageLiteral(resourceName: "iconSettings.pdf"))
        settings.addTarget(presenter, action:#selector(presenter.settings), for:.touchUpInside)
        let bar = Bar(.localized("HomeView.title"), left:[settings], right:[map])
        view.addSubview(bar)
        
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        scroll.indicatorStyle = .white
        view.addSubview(scroll)
        self.scroll = scroll
        
        let items = UIView()
        scroll.addSubview(items)
        self.items = items
        
        bar.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        scroll.topAnchor.constraint(equalTo:bar.bottomAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            bar.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            bar.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        }
    }
    
    private func configureViewModel() {
        presenter.viewModel { [weak self] (items:[HomeItem]) in self?.update(items:items) }
    }
    
    private func update(items:[HomeItem]) {
        var top = self.items.topAnchor
        items.forEach { item in
            let cell = HomeCellView()
            self.items.addSubview(cell)
            
            cell.topAnchor.constraint(equalTo:top, constant:20).isActive = true
            cell.leftAnchor.constraint(equalTo:self.items.leftAnchor, constant:20).isActive = true
            cell.rightAnchor.constraint(equalTo:self.items.rightAnchor, constant:-20).isActive = true
            cell.heightAnchor.constraint(equalToConstant:60).isActive = true
            top = cell.bottomAnchor
        }
        layoutItems(size:view.bounds.size)
    }
    
    private func layoutItems(size:CGSize) {
        items.frame = CGRect(x:0, y:0, width:size.width, height:CGFloat(items.subviews.count) * 100)
        scroll.contentSize = items.bounds.size
    }
}
