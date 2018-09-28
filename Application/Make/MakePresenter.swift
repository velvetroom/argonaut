import CleanArchitecture
import Argonaut
import MapKit

class MakePresenter:Presenter {
    private let map = Map()
    
    func save(rect:MKMapRect) {
        map.onSuccess = { url in
            let view = TestView()
            view.url = url
            Application.navigation.pushViewController(view, animated:true)
        }
        map.onFail = { error in
            print(error)
        }
//        map.makeMap(rect:rect)
    }
    
    @objc func cancel() {
        Application.navigation.popViewController(animated:true)
    }
}
