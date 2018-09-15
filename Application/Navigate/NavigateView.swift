import CleanArchitecture

class NavigateView:View<NavigatePresenter> {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Navigate"
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
        }
    }
}
