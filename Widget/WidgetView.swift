import UIKit
import NotificationCenter
import CoreLocation

@objc(WidgetView) class WidgetView:UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    private weak var origin:WidgetCellView?
    private weak var destination:WidgetCellView?
    private weak var effect:UIVisualEffectView!
    private weak var image:UIImageView!
    private weak var label:UILabel!
    private var widget:Widget?
    private let location = CLLocationManager()
 
    deinit {
        location.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let effect:UIVisualEffectView
        if #available(iOSApplicationExtension 10.0, *) {
            effect = UIVisualEffectView(effect:UIVibrancyEffect.widgetPrimary())
        } else {
            effect = UIVisualEffectView(effect:UIVibrancyEffect.notificationCenter())
        }
        effect.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(effect)
        self.effect = effect
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.font = .systemFont(ofSize:15, weight:.light)
        label.text = NSLocalizedString("View.label", comment:String())
        label.textColor = .black
        label.textAlignment = .center
        label.isHidden = true
        effect.contentView.addSubview(label)
        self.label = label
        
        let image = UIImageView(image:#imageLiteral(resourceName: "iconPointer.pdf"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .center
        image.isUserInteractionEnabled = false
        image.isHidden = true
        effect.contentView.addSubview(image)
        self.image = image
        
        let button = UIControl()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action:#selector(open), for:.touchUpInside)
        button.addTarget(self, action:#selector(highlight), for:.touchDown)
        button.addTarget(self, action:#selector(unhighlight), for:[.touchUpOutside, .touchUpInside, .touchCancel])
        view.addSubview(button)
        
        effect.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        effect.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        effect.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        effect.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        label.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        image.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant:30).isActive = true
        image.heightAnchor.constraint(equalToConstant:30).isActive = true
        image.leftAnchor.constraint(equalTo:label.rightAnchor).isActive = true
        
        button.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        button.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        button.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyHundredMeters
        location.distanceFilter = 100
    }
    
    override func viewDidDisappear(_ animated:Bool) {
        super.viewDidDisappear(animated)
        location.stopUpdatingLocation()
    }
    
    func widgetPerformUpdate(completionHandler:(@escaping(NCUpdateResult) -> Void)) {
        if let widget = Widget.load() {
            self.widget = widget
            show()
            location.startUpdatingLocation()
            completionHandler(.newData)
        } else {
            label.isHidden = false
            image.isHidden = false
            location.stopUpdatingLocation()
            completionHandler(.noData)
        }
    }
    
    func locationManager(_:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        origin?.update(user:locations.last!)
        destination?.update(user:locations.last!)
    }
    
    private func show() {
        let origin = WidgetCellView(widget!.origin)
        effect.contentView.addSubview(origin)
        self.origin = origin
        
        let destination = WidgetCellView(widget!.destination)
        effect.contentView.addSubview(destination)
        self.destination = destination
        
        origin.topAnchor.constraint(equalTo:view.topAnchor, constant:12).isActive = true
        origin.bottomAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        origin.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        origin.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        destination.topAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        destination.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant:-12).isActive = true
        destination.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        destination.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
    }
    
    @objc private func highlight() { view.alpha = 0.2 }
    @objc private func unhighlight() { view.alpha = 1 }
    
    @objc private func open() {
        var url = "argonaut:"
        if let id = widget?.id { url += "map=" + id }
        extensionContext?.open(URL(string:url)!, completionHandler:nil)
    }
}
