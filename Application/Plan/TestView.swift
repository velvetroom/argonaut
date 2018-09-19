import MapKit

class TestView:UIViewController {
    var url:URL?
    private weak var map:MapView!
    let tiler = TestTiler()
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tiler.url = url
        
        
        view.backgroundColor = .black
        
        let map = MapView()
        map.addOverlay(tiler, level:.aboveLabels)
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
