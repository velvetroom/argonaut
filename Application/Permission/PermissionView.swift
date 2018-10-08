import CleanArchitecture
import CoreLocation

class PermissionView:View<PermissionPresenter>, CLLocationManagerDelegate {
    private weak var requestButton:ButtonBlue!
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
        
        let requestButton = ButtonBlue(.local("PermissionView.requestButton"))
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
