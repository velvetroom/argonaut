import UIKit

class PlanResultView:UIControl {
    var item:NSObject!
    
    func configure(text:NSAttributedString) {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = .white
        label.attributedText = text
        addSubview(label)
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.isUserInteractionEnabled = false
        border.backgroundColor = UIColor(white:1, alpha:0.2)
        addSubview(border)
        
        label.topAnchor.constraint(equalTo:topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        label.leftAnchor.constraint(equalTo:leftAnchor, constant:20).isActive = true
        label.rightAnchor.constraint(equalTo:rightAnchor, constant:-20).isActive = true
        
        border.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        border.leftAnchor.constraint(equalTo:leftAnchor, constant:20).isActive = true
        border.rightAnchor.constraint(equalTo:rightAnchor, constant:-20).isActive = true
        border.heightAnchor.constraint(equalToConstant:1).isActive = true
    }
    
    override var isSelected:Bool { didSet { update() } }
    override var isHighlighted:Bool { didSet { update() } }
    
    private func update() {
        if isSelected || isHighlighted {
            alpha = 0.3
        } else {
            alpha = 1
        }
    }
}
