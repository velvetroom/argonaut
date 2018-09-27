import CleanArchitecture
import Argonaut
import MapKit

class PlanPresenter:Presenter {
    private let map = Map()
    
    @available(iOS 9.3, *)
    func update(results:[MKLocalSearchCompletion]) {
        DispatchQueue.global(qos:.background).async { [weak self] in
            
        }
    }
    
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
    }
    
    override func didLoad() {
        
    }
}
