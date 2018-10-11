import UIKit
import NotificationCenter

@objc(WidgetView) class WidgetView:UIViewController, NCWidgetProviding {
    private weak var image:UIImageView!
    private weak var label:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let effect:UIVisualEffectView
        if #available(iOSApplicationExtension 10.0, *) {
            effect = UIVisualEffectView(effect:UIVibrancyEffect.widgetPrimary())
        } else {
            effect = UIVisualEffectView(effect:UIVibrancyEffect.notificationCenter())
        }
        view.addSubview(effect)
        effect.translatesAutoresizingMaskIntoConstraints = false
        effect.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        effect.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        effect.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        effect.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.font = .systemFont(ofSize:15, weight:.light)
        label.text = "Select a map"
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
        
        label.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        image.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant:30).isActive = true
        image.heightAnchor.constraint(equalToConstant:30).isActive = true
        image.leftAnchor.constraint(equalTo:label.rightAnchor, constant:5).isActive = true
    }
    
    func widgetPerformUpdate(completionHandler:(@escaping(NCUpdateResult) -> Void)) {
        if let widget = Widget.load() {
            completionHandler(.newData)
        } else {
            label.isHidden = false
            image.isHidden = false
            completionHandler(.noData)
        }
    }
    
//    @objc private func selected(cell:TodayCellView) {
//        if let url:URL = URL(string:"catban:board=\(cell.item.board)") {
//            extensionContext?.open(url, completionHandler:nil)
//        }
//    }
}
