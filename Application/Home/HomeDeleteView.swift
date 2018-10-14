import CleanArchitecture

class HomeDeleteView:View<HomePresenter> {
    var viewModel:HomeItem!
    override var preferredStatusBarStyle:UIStatusBarStyle { return .lightContent }
    override var modalPresentationStyle:UIModalPresentationStyle { get { return .overCurrentContext } set {} }
    override var modalTransitionStyle:UIModalTransitionStyle { get { return .crossDissolve } set {} }
    
    override func viewDidLoad() {
        makeOutlets()
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    func makeOutlets() {
        let blur = UIVisualEffectView(effect:UIBlurEffect(style:.dark))
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.isUserInteractionEnabled = false
        blur.alpha = 0.8
        view.addSubview(blur)
        
        let back = UIControl()
        back.translatesAutoresizingMaskIntoConstraints = false
        back.addTarget(presenter, action:#selector(presenter.deleteCancel), for:.touchUpInside)
        view.addSubview(back)
        
        let base = UIView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = .white
        base.layer.cornerRadius = 8
        base.clipsToBounds = true
        view.addSubview(base)
        
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize:18, weight:.light)
        label.attributedText = viewModel.title
        label.textAlignment = .center
        label.numberOfLines = 0
        view.addSubview(label)
        
        let cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(presenter, action:#selector(presenter.deleteCancel), for:.touchUpInside)
        cancel.setTitleColor(UIColor(white:0, alpha:0.6), for:.normal)
        cancel.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        cancel.setTitle(.local("HomeDeleteView.cancel"), for:[])
        cancel.titleLabel!.font = .systemFont(ofSize:14, weight:.regular)
        base.addSubview(cancel)
        
        let delete = UIButton()
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.addTarget(self, action:#selector(confirm), for:.touchUpInside)
        delete.backgroundColor = .bloodRed
        delete.setTitleColor(.white, for:.normal)
        delete.setTitleColor(UIColor(white:1, alpha:0.3), for:.highlighted)
        delete.setTitle(.local("HomeDeleteView.delete"), for:[])
        delete.titleLabel!.font = .systemFont(ofSize:14, weight:.bold)
        delete.layer.cornerRadius = 6
        base.addSubview(delete)
        
        base.widthAnchor.constraint(equalToConstant:320).isActive = true
        base.heightAnchor.constraint(equalToConstant:200).isActive = true
        base.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        base.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        label.topAnchor.constraint(equalTo:base.topAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo:base.centerXAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant:95).isActive = true
        
        cancel.leftAnchor.constraint(equalTo:base.leftAnchor).isActive = true
        cancel.rightAnchor.constraint(equalTo:base.rightAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo:delete.bottomAnchor).isActive = true
        cancel.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        delete.leftAnchor.constraint(equalTo:base.leftAnchor, constant:14).isActive = true
        delete.rightAnchor.constraint(equalTo:base.rightAnchor, constant:-14).isActive = true
        delete.topAnchor.constraint(equalTo:label.bottomAnchor).isActive = true
        delete.heightAnchor.constraint(equalToConstant:48).isActive = true
        
        blur.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        back.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        back.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        back.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        back.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
    }
    
    @objc private func confirm() {
        presenter.deleteConfirm(project:viewModel.project)
    }
}
