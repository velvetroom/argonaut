import UIKit

class PlanTypeView:UIView {
    private(set) weak var control:UIControl!
    private(set) weak var image:UIImageView!
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 16
        makeOutlets()
        notSelected()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    func selected() {
        image.alpha = 1
        backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.2431372549, blue: 0.4941176471, alpha: 1)
    }
    
    func notSelected() {
        image.alpha = 0.35
        backgroundColor = .clear
    }
    
    private func makeOutlets() {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .center
        image.isUserInteractionEnabled = false
        addSubview(image)
        self.image = image
        
        let control = UIControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        addSubview(control)
        self.control = control
        
        image.topAnchor.constraint(equalTo:topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        
        control.topAnchor.constraint(equalTo:topAnchor).isActive = true
        control.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        control.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        control.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
}
