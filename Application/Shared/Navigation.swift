import UIKit

class Navigation:UINavigationController {
    override var preferredStatusBarStyle:UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated:false)
        setViewControllers([PermissionView()], animated:false)
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        if let gesture = interactivePopGestureRecognizer {
            view.removeGestureRecognizer(gesture)
        }
    }
}
