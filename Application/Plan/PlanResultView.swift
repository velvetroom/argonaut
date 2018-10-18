import UIKit

class PlanResultView:UIControl {
    var item:NSObject!
    private weak var base:UIView!
    private weak var label:UILabel!
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder:NSCoder) { return nil }
    override var intrinsicContentSize:CGSize { return CGSize(width:UIView.noIntrinsicMetric, height:56) }
    
    func configure(text:NSAttributedString) {
        let base = UIView()
        base.isUserInteractionEnabled = false
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = .greekBlue
        base.layer.cornerRadius = 6
        base.clipsToBounds = true
        base.isHidden = true
        addSubview(base)
        self.base = base
        
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = .white
        label.attributedText = text
        addSubview(label)
        self.label = label
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.isUserInteractionEnabled = false
        border.backgroundColor = UIColor(white:1, alpha:0.2)
        addSubview(border)
        
        base.topAnchor.constraint(equalTo:topAnchor, constant:5).isActive = true
        base.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-5).isActive = true
        base.leftAnchor.constraint(equalTo:leftAnchor, constant:10).isActive = true
        base.rightAnchor.constraint(equalTo:rightAnchor, constant:-10).isActive = true
        
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
            base.isHidden = false
            label.textColor = .black
        } else {
            base.isHidden = true
            label.textColor = .white
        }
    }
}
