import UIKit
import CoreLocation

class WidgetCellView:UIView {
    private let location:CLLocation
    private weak var distance:UILabel!
    
    init(_ mark:WidgetMark) {
        location = CLLocation(latitude:mark.latitude, longitude:mark.longitude)
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        
        let icon = UIImageView(image:#imageLiteral(resourceName: "iconLocation.pdf"))
        icon.isUserInteractionEnabled = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.clipsToBounds = true
        icon.contentMode = .center
        addSubview(icon)
        
        let title = UILabel()
        title.isUserInteractionEnabled = false
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize:13, weight:.light)
        title.textColor = .black
        title.text = mark.title
        addSubview(title)
        
        let distance = UILabel()
        distance.isUserInteractionEnabled = false
        distance.translatesAutoresizingMaskIntoConstraints = false
        distance.font = .systemFont(ofSize:14, weight:.medium)
        distance.textColor = .black
        distance.textAlignment = .right
        addSubview(distance)
        self.distance = distance
        
        icon.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        icon.leftAnchor.constraint(equalTo:leftAnchor, constant:10).isActive = true
        icon.widthAnchor.constraint(equalToConstant:18).isActive = true
        icon.heightAnchor.constraint(equalToConstant:18).isActive = true
        
        title.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo:icon.rightAnchor, constant:6).isActive = true
        
        distance.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        distance.rightAnchor.constraint(equalTo:rightAnchor, constant:-20).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func update(user:CLLocation) {
        guard #available(iOS 10.0, *) else { return }
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .long
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter.maximumFractionDigits = 1
        location.distance(from:user)
        distance.text = formatter.string(from:Measurement(value:location.distance(from:user),
                                                          unit:UnitLength.meters)) as String
    }
}
