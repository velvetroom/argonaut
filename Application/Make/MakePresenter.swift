import CleanArchitecture
import Argonaut
import MapKit

class MakePresenter:Presenter {
    var plan:[MKAnnotation]!
    private let map = Map()
    
    override func didLoad() {
        map.onSuccess = { url in
            let view = TravelView()
            view.tiler.url = url
            Application.navigation.setViewControllers([view], animated:true)
        }
        map.onFail = { error in
            print(error)
        }
        map.onProgress = { [weak self] progress in
            self?.update(viewModel:progress)
        }
        
        map.makeMap(points:plan)
    }
    
    @objc func cancel() {
        Application.navigation.popViewController(animated:true)
    }
}
