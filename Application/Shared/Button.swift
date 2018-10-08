import UIKit

class Button:UIControl {
    override var intrinsicContentSize:CGSize { return CGSize(width:52, height:56) }
    
    init(_ image:UIImage) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image:image)
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo:topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override var isHighlighted:Bool { didSet { update() } }
    override var isSelected:Bool { didSet { update() } }
    
    private func update() {
        if isSelected || isHighlighted {
            alpha = 0.2
        } else {
            alpha = 1
        }
    }
}
