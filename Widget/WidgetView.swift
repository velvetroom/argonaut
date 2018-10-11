import UIKit
import NotificationCenter
import CoreLocation

@objc(WidgetView) class WidgetView:UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    private weak var origin:WidgetCellView?
    private weak var destination:WidgetCellView?
    private weak var effect:UIVisualEffectView!
    private weak var image:UIImageView!
    private weak var label:UILabel!
    private let location = CLLocationManager()
    
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
        label.text = "Select Map"
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
            show(widget:widget)
            location.startUpdatingLocation()
            completionHandler(.newData)
        } else {
            label.isHidden = false
            image.isHidden = false
            completionHandler(.noData)
        }
    }
    
    func locationManager(_:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        origin?.update(user:locations.last!)
        destination?.update(user:locations.last!)
    }
    
    private func show(widget:Widget) {
        let user = UIImageView(image:#imageLiteral(resourceName: "iconUser.pdf"))
        user.translatesAutoresizingMaskIntoConstraints = false
        user.clipsToBounds = true
        user.isUserInteractionEnabled = false
        user.contentMode = .center
        effect.contentView.addSubview(user)
        
        let origin = WidgetCellView(widget.origin, align:.left)
        effect.contentView.addSubview(origin)
        self.origin = origin
        
        let destination = WidgetCellView(widget.destination, align:.right)
        effect.contentView.addSubview(destination)
        self.destination = destination
        
        user.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        user.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        user.widthAnchor.constraint(equalToConstant:78).isActive = true
        user.heightAnchor.constraint(equalToConstant:38).isActive = true
        
        origin.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        origin.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        origin.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        origin.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.5).isActive = true
        
        destination.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        destination.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        destination.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        destination.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier:0.5).isActive = true
    }
    
    @objc private func open() { extensionContext?.open(URL(string:"argonaut:")!, completionHandler:nil) }
    @objc private func highlight() { view.alpha = 0.2 }
    @objc private func unhighlight() { view.alpha = 1 }
}
