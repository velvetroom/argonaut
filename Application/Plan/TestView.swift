import MapKit

class TestView:UIViewController {
    var url:URL?
    private weak var map:MapView!
    let tiler = TestTiler()
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tiler.url = url
        
        Application.navigation.present(UIActivityViewController(activityItems:[url!], applicationActivities:nil), animated:true)
        
        
        view.backgroundColor = .black
        
        let map = MapView()
        map.addOverlay(tiler, level:.aboveLabels)
        var region = MKCoordinateRegion()
        region.span.latitudeDelta = 0.002
        region.span.longitudeDelta = 0.002
        region.center = CLLocationCoordinate2D(latitude:52.521912, longitude:13.413354)
        map.setRegion(region, animated:false)
        self.map = map
        view.addSubview(map)
        map.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        map.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        map.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        /*let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        view.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true

 */
    }
}
