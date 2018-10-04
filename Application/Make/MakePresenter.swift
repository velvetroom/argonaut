import CleanArchitecture
import Argonaut
import MapKit

class MakePresenter:Presenter {
    var plan:[MKAnnotation]!
    var route:MKRoute?
    private let map = Map()
    
    override func didLoad() {
        map.onSuccess = { project in
            let view = TravelView()
            view.presenter.project = project
            Application.navigation.setViewControllers([view], animated:true)
        }
        map.onFail = { error in
            print(error)
        }
        map.onProgress = { [weak self] progress in
            self?.update(viewModel:progress)
        }
        
        map.makeMap(points:plan, route:route)
    }
    
    @objc func cancel() {
        Application.navigation.popViewController(animated:true)
    }
}
