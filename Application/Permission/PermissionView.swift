import CleanArchitecture
import CoreLocation

class PermissionView:View<PermissionPresenter>, CLLocationManagerDelegate {
    private weak var requestButton:UIButton!
    private weak var message:UILabel!
    private var manager:CLLocationManager?
    override var preferredStatusBarStyle:UIStatusBarStyle { return .lightContent }
    
    func locationManager(_:CLLocationManager, didChangeAuthorization status:CLAuthorizationStatus) {
        if status != .notDetermined {
            checkStatus()
        }
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        makeOutlets()
        configureViewModel()
        super.viewDidLoad()
        checkStatus()
    }
    
    private func makeOutlets() {
        let icon = UIImageView(image:#imageLiteral(resourceName: "iconLogo.pdf"))
        icon.isUserInteractionEnabled = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.clipsToBounds = true
        icon.contentMode = .center
        view.addSubview(icon)
        
        let message = UILabel()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.numberOfLines = 0
        message.textColor = .white
        view.addSubview(message)
        self.message = message
        
        let requestButton = UIButton()
        requestButton.translatesAutoresizingMaskIntoConstraints = false
        requestButton.clipsToBounds = true
        requestButton.layer.cornerRadius = 6
        requestButton.backgroundColor = .greekBlue
        requestButton.setTitleColor(.black, for:.normal)
        requestButton.setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        requestButton.setTitle(.local("PermissionView.requestButton"), for:[])
        requestButton.titleLabel!.font = .systemFont(ofSize:14, weight:.light)
        requestButton.addTarget(self, action:#selector(request), for:.touchUpInside)
        requestButton.isHidden = true
        view.addSubview(requestButton)
        self.requestButton = requestButton
        
        icon.widthAnchor.constraint(equalToConstant:75).isActive = true
        icon.heightAnchor.constraint(equalToConstant:75).isActive = true
        icon.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        message.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        message.topAnchor.constraint(equalTo:icon.bottomAnchor, constant:40).isActive = true
        message.widthAnchor.constraint(equalToConstant:280).isActive = true
        
        requestButton.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        requestButton.topAnchor.constraint(equalTo:message.bottomAnchor, constant:40).isActive = true
        requestButton.widthAnchor.constraint(equalToConstant:120).isActive = true
        requestButton.heightAnchor.constraint(equalToConstant:32).isActive = true
    }
    
    private func configureViewModel() {
        presenter.viewModel { [weak self] (viewModel:Permission) in
            self?.requestButton.isHidden = viewModel.requestButtonHidden
            self?.message.attributedText = viewModel.message
        }
    }
    
    private func checkStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse, .restricted: presenter.done()
        case .denied: presenter.denied()
        case .notDetermined: presenter.notDetermined()
        }
    }
    
    @objc private func request() {
        manager = CLLocationManager()
        manager!.delegate = self
        manager!.requestWhenInUseAuthorization()
    }
}
