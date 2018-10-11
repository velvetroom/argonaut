import UIKit
import Argonaut

class Navigation:UINavigationController {
    private let session = Factory.makeSession()
    override var preferredStatusBarStyle:UIStatusBarStyle { return .lightContent }
    
    func launchDefault() { setViewControllers([PermissionView()], animated:false) }
    
    func open(map:String) {
        dismiss(animated:false)
        session.load(project:map) { [weak self] project in
            let view = TravelView()
            view.presenter.project = project
            self?.setViewControllers([view], animated:true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated:false)
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        if let gesture = interactivePopGestureRecognizer {
            view.removeGestureRecognizer(gesture)
        }
    }
}
