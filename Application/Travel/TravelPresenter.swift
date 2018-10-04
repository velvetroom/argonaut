import CleanArchitecture
import Argonaut
import MapKit

class TravelPresenter:Presenter {
    var project:Project!
    
    override func didLoad() {
        update(viewModel:[makeAnnotation(mark:project.origin), makeAnnotation(mark:project.destination)])
        update(viewModel:makePolyline(points:project.route))
    }
    
    private func makeAnnotation(mark:Mark) -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = mark.title
        annotation.coordinate.latitude = mark.point.latitude
        annotation.coordinate.longitude = mark.point.longitude
        return annotation
    }
    
    private func makePolyline(points:[Point]) -> MKPolyline {
        let list = points.map { CLLocationCoordinate2D(latitude:$0.latitude, longitude:$0.longitude) }
        return MKPolyline(coordinates:list, count:list.count)
    }
}
