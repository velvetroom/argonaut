import CleanArchitecture
import Argonaut
import MapKit
import StoreKit

class MakePresenter:Presenter {
    var plan:[MKAnnotation]!
    var route:MKRoute?
    private let session = Factory.makeSession()
    private let map = Map()
    
    override func didLoad() {
        map.onSuccess = { [weak self] project in self?.success(project:project) }
        map.onFail = { _ in }
        map.onProgress = { [weak self] progress in
            self?.update(viewModel:progress)
        }
        
        map.makeMap(points:plan, route:route)
    }
    
    @objc func cancel() {
        Application.navigation.popViewController(animated:true)
    }
    
    private func success(project:Project) {
        let view = TravelView()
        view.presenter.project = project
        Application.navigation.setViewControllers([view], animated:true)
        if session.rate() { if #available(iOS 10.3, *) { SKStoreReviewController.requestReview() } }
    }
}
