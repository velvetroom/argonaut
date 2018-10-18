import UIKit

class HomeCellView:UIControl {
    var viewModel:HomeItem! { didSet {
        label.attributedText = viewModel.title
    }}
    private(set) weak var button:UIButton!
    private weak var label:UILabel!
    override var intrinsicContentSize:CGSize { return CGSize(width:UIView.noIntrinsicMetric, height:70) }
    
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
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "iconDelete.pdf"), for:[])
        button.imageView!.clipsToBounds = true
        button.imageView!.contentMode = .center
        button.imageEdgeInsets = UIEdgeInsets(top:0, left:10, bottom:0, right:0)
        addSubview(button)
        self.button = button
        
        label.topAnchor.constraint(equalTo:topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        label.leftAnchor.constraint(equalTo:leftAnchor, constant:15).isActive = true
        label.rightAnchor.constraint(equalTo:button.leftAnchor).isActive = true
        
        button.topAnchor.constraint(equalTo:topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        button.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant:65).isActive = true
    }
    
    private func update() {
        if isSelected || isHighlighted {
            backgroundColor = .greekBlue
            label.textColor = .black
        } else {
            backgroundColor = .midnightBlue
            label.textColor = .white
        }
    }
}
