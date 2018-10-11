import CleanArchitecture
import Argonaut
import MapKit

class TravelPresenter:Presenter {
    var project:Project!
    
    @objc func close() {
        Application.navigation.setViewControllers([HomeView()], animated:true)
    }
    
    override func didLoad() {
        update(viewModel:[makeAnnotation(mark:project.origin), makeAnnotation(mark:project.destination)])
        update(viewModel:makePolyline(points:project.route))
        DispatchQueue.global(qos:.background).async { [weak self] in self?.makeWidget() }
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
    
    private func makeWidget() {
        let widget = Widget()
        widget.id = project.id
        widget.origin = make(mark:project.origin)
        widget.destination = make(mark:project.destination)
        widget.store()
    }
    
    private func make(mark:Mark) -> WidgetMark {
        var widget = WidgetMark()
        widget.title = mark.title
        widget.latitude = mark.point.latitude
        widget.longitude = mark.point.longitude
        return widget
    }
}
