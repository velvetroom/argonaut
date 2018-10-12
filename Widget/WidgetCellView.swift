import UIKit
import CoreLocation

class WidgetCellView:UIView {
    private let location:CLLocation
    private weak var distance:UILabel!
    
    init(_ mark:WidgetMark, align:NSTextAlignment) {
        location = CLLocation(latitude:mark.latitude, longitude:mark.longitude)
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        
        let title = UILabel()
        title.isUserInteractionEnabled = false
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize:12, weight:.medium)
        title.textColor = .black
        title.text = mark.title
        title.textAlignment = align
        addSubview(title)
        
        let distance = UILabel()
        distance.isUserInteractionEnabled = false
        distance.translatesAutoresizingMaskIntoConstraints = false
        distance.font = .systemFont(ofSize:12, weight:.ultraLight)
        distance.textColor = .black
        distance.textAlignment = align
        addSubview(distance)
        self.distance = distance
        
        title.centerYAnchor.constraint(equalTo:centerYAnchor, constant:-7).isActive = true
        title.leftAnchor.constraint(equalTo:leftAnchor, constant:11).isActive = true
        title.rightAnchor.constraint(equalTo:rightAnchor, constant:-11).isActive = true
        
        distance.topAnchor.constraint(equalTo:title.bottomAnchor).isActive = true
        distance.leftAnchor.constraint(equalTo:title.leftAnchor).isActive = true
        distance.rightAnchor.constraint(equalTo:title.rightAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func update(user:CLLocation) {
        guard #available(iOS 10.0, *) else { return }
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .long
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter.maximumFractionDigits = 3
        location.distance(from:user)
        distance.text = formatter.string(from:Measurement(value:location.distance(from:user),
                                                          unit:UnitLength.meters)) as String
    }
}
