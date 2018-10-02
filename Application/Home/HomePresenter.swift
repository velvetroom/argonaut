import CleanArchitecture

class HomePresenter:Presenter {
    @objc func map() {
        Application.navigation.pushViewController(PlanView(), animated:true)
    }
    
    @objc func settings() {
        Application.navigation.pushViewController(SettingsView(), animated:true)
    }
    
    override func didAppear() {
        update(viewModel:[HomeItem()])
    }
}
