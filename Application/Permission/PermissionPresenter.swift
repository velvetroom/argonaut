import CleanArchitecture
import MarkdownHero

class PermissionPresenter:Presenter {
    private let parser = Parser()
    
    func denied() {
        var viewModel = Permission()
        viewModel.message = parser.parse(string:.localized("PermissionPresenter.denied"))
        update(viewModel:viewModel)
    }
    
    func notDetermined() {
        var viewModel = Permission()
        viewModel.message = parser.parse(string:.localized("PermissionPresenter.notDetermined"))
        viewModel.requestButtonHidden = false
        update(viewModel:viewModel)
    }
    
    func done() {
        Application.navigation.setViewControllers([HomeView()], animated:false)
    }
}
