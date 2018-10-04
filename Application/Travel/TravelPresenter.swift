import CleanArchitecture
import Argonaut
import MapKit

class TravelPresenter:Presenter {
    var project:Project!
    
    override func didLoad() {
        update(viewModel:[makeAnnotation(point:project.origin), makeAnnotation(point:project.destination)])
        update(viewModel:makePolyline(points:project.route))
    }
    
    private func makeAnnotation(point:Point) -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = point.latitude
        annotation.coordinate.longitude = point.longitude
        return annotation
    }
    
    private func makePolyline(points:[Point]) -> MKPolyline {
        let list = points.map { CLLocationCoordinate2D(latitude:$0.latitude, longitude:$0.longitude) }
        return MKPolyline(coordinates:list, count:list.count)
    }
}
