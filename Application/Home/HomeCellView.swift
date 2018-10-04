import UIKit

class HomeCellView:UIControl {
    var viewModel:HomeItem! { didSet {
        label.attributedText = viewModel.title
    }}
    private weak var label:UILabel!
    
    init() {
        super.init(frame:.zero)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .midnightBlue
        layer.cornerRadius = 6
        makeOutlets()
    }
    
    required init?(coder:NSCoder) { return nil }
    override var isSelected:Bool { didSet { update() } }
    override var isHighlighted:Bool { didSet { update() } }
    
    private func makeOutlets() {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        addSubview(label)
        self.label = label
        
        label.topAnchor.constraint(equalTo:topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        label.leftAnchor.constraint(equalTo:leftAnchor, constant:10).isActive = true
        label.rightAnchor.constraint(equalTo:rightAnchor, constant:-10).isActive = true
    }
    
    private func update() {
        if isSelected || isHighlighted {
            alpha = 0.2
        } else {
            alpha = 1
        }
    }
}
