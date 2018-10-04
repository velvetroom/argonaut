import CleanArchitecture
import Argonaut

class HomePresenter:Presenter {
    private let session = Factory.makeSession()
    
    @objc func map() {
        Application.navigation.pushViewController(PlanView(), animated:true)
    }
    
    @objc func open(cell:HomeCellView) {
        let view = TravelView()
        view.presenter.project = cell.viewModel.project
        Application.navigation.setViewControllers([view], animated:true)
    }
    
    @objc func settings() {
        Application.navigation.setViewControllers([SettingsView()], animated:true)
    }
    
    override func didAppear() {
        session.load { [weak self] (projects:[Project]) in
            let items = projects.map { project -> HomeItem in
                var item = HomeItem()
                item.project = project
                item.title = project.origin.title
                return item
            }
            self?.update(viewModel:items)
        }
    }
}
