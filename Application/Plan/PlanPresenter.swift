import CleanArchitecture
import Argonaut
import MapKit

class PlanPresenter:Presenter {
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
        map.makeMap(rect:rect)
//        map.makeMap(rect:rect, success: { image in

//        }) { error in
//            print(error)
//        }
    }
}
