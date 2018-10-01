import CleanArchitecture

class PermissionPresenter:Presenter {
    func done() {
        Application.navigation.setViewControllers([HomeView()], animated:true)
    }
}
