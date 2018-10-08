import CleanArchitecture

class HomeView:View<HomePresenter> {
    private weak var scroll:UIScrollView!
    private weak var items:UIView!
    private weak var icon:UIImageView!
    private weak var button:ButtonBlue!
    private weak var bar:Bar!
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
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        scroll.indicatorStyle = .white
        view.addSubview(scroll)
        self.scroll = scroll
        
        let map = Button(#imageLiteral(resourceName: "iconMap.pdf"))
        map.addTarget(presenter, action:#selector(presenter.planMap), for:.touchUpInside)
        let settings = Button(#imageLiteral(resourceName: "iconSettings.pdf"))
        settings.addTarget(presenter, action:#selector(presenter.settings), for:.touchUpInside)
        let bar = Bar(.local("HomeView.title"), right:[map])
        view.addSubview(bar)
        self.bar = bar
        
        let items = UIView()
        scroll.addSubview(items)
        self.items = items
        
        let icon = UIImageView(image:#imageLiteral(resourceName: "iconLogo.pdf"))
        icon.isUserInteractionEnabled = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.clipsToBounds = true
        icon.contentMode = .center
        view.addSubview(icon)
        self.icon = icon
        
        let button = ButtonBlue(.local("HomeView.button"))
        button.addTarget(presenter, action:#selector(presenter.planMap), for:.touchUpInside)
        button.isHidden = true
        view.addSubview(button)
        self.button = button
        
        bar.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        bar.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        scroll.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        icon.widthAnchor.constraint(equalToConstant:75).isActive = true
        icon.heightAnchor.constraint(equalToConstant:75).isActive = true
        icon.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        button.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo:icon.bottomAnchor, constant:20).isActive = true
    }
    
    private func configureViewModel() {
        presenter.viewModel { [weak self] (viewModel:Home) in self?.update(viewModel:viewModel) }
    }
    
    private func update(viewModel:Home) {
        var top = items.topAnchor
        viewModel.items.forEach { item in
            let cell = HomeCellView()
            cell.viewModel = item
            cell.addTarget(presenter, action:#selector(presenter.open(cell:)), for:.touchUpInside)
            items.addSubview(cell)
            
            cell.topAnchor.constraint(equalTo:top, constant:20).isActive = true
            cell.leftAnchor.constraint(equalTo:self.items.leftAnchor, constant:20).isActive = true
            cell.rightAnchor.constraint(equalTo:self.items.rightAnchor, constant:-20).isActive = true
            cell.heightAnchor.constraint(equalToConstant:60).isActive = true
            top = cell.bottomAnchor
        }
        layoutItems(size:view.bounds.size)
        icon.isHidden = viewModel.iconHidden
        button.isHidden = viewModel.buttonHidden
    }
    
    private func layoutItems(size:CGSize) {
        items.frame = CGRect(x:0, y:60, width:size.width, height:(CGFloat(items.subviews.count) * 80) + 20)
        scroll.contentSize = CGSize(width:size.width, height:items.frame.maxY)
    }
}
