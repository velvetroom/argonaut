import CleanArchitecture

class SettingsView:View<SettingsPresenter> {
    override var preferredStatusBarStyle:UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        makeOutlets()
    }
    
    private func makeOutlets() {
        let close = Button(image:#imageLiteral(resourceName: "iconCancel.pdf"))
        close.addTarget(presenter, action:#selector(presenter.close), for:.touchUpInside)
        let bar = Bar(.localized("SettingsView.title"), left:[close])
        view.addSubview(bar)
        
        bar.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            bar.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            bar.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        }
    }
}
