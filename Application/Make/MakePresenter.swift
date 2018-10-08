import CleanArchitecture
import Argonaut
import MapKit
import StoreKit
import MarkdownHero

class MakePresenter:Presenter {
    var plan:[MKAnnotation]!
    var route:MKRoute?
    private let session = Factory.makeSession()
    private let map = Map()
    private let parser = Parser()
    
    override func didLoad() {
        map.onSuccess = { [weak self] project in self?.success(project:project) }
        map.onFail = { [weak self] error in self?.fail(error:error) }
        map.onProgress = { [weak self] progress in self?.update(viewModel:progress) }
        map.makeMap(points:plan, route:route)
    }
    
    @objc func cancel() {
        Application.navigation.popViewController(animated:true)
    }
    
    @objc func retry() {
        update(viewModel:Make())
        map.retry()
    }
    
    private func success(project:Project) {
        let view = TravelView()
        view.presenter.project = project
        Application.navigation.setViewControllers([view], animated:true)
        if session.rate() { if #available(iOS 10.3, *) { SKStoreReviewController.requestReview() } }
    }
    
    private func fail(error:Error) {
        var viewModel = Make()
        viewModel.loadHidden = true
        viewModel.errorHidden = false
        viewModel.retryHidden = false
        switch error {
        case Exception.mapTimeout: viewModel.message = parser.parse(string:.local("MakePresenter.errorTimeout"))
        default: viewModel.message = parser.parse(string:.local("MakePresenter.errorUnknown"))
        }
        update(viewModel:viewModel)
    }
}
