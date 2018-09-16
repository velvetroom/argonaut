import CleanArchitecture
import Argonaut
import MapKit

class PlanPresenter:Presenter {
    private let map = Map()
    
    func save(rect:MKMapRect) {
        map.create(rect:rect, success: { image in
            let view = TestView()
            view.image = image
            Application.navigation.pushViewController(view, animated:true)
        }) { error in
            print(error)
        }
    }
}
