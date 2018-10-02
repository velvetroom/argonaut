import CleanArchitecture

class SettingsPresenter:Presenter {
    @objc func close() {
        Application.navigation.setViewControllers([HomeView()], animated:true)
    }
}
