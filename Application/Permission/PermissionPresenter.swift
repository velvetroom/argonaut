import CleanArchitecture

class PermissionPresenter:Presenter {
    func done() {
        Application.navigation.setViewControllers([PlanView()], animated:true)
    }
}
