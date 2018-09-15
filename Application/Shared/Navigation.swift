import UIKit

class Navigation:UINavigationController {
    override var preferredStatusBarStyle:UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        setViewControllers([NavigateView()], animated:false)
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        if let gesture = interactivePopGestureRecognizer {
            view.removeGestureRecognizer(gesture)
        }
    }
    
    private func configureNavigation() {
        navigationBar.barTintColor = .black
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [.foregroundColor:UIColor.white]
        navigationBar.setValue(true, forKey:"hidesShadow")
        navigationBar.isTranslucent = false
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            navigationBar.largeTitleTextAttributes = [.foregroundColor:UIColor.white]
        }
    }
}
