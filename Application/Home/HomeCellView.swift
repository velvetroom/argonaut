import UIKit

class HomeCellView:UIControl {
    var viewModel:HomeItem! { didSet {
        label.text = viewModel.title
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
    
    private func makeOutlets() {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        addSubview(label)
        self.label = label
        
        label.topAnchor.constraint(equalTo:topAnchor, constant:5).isActive = true
        label.leftAnchor.constraint(equalTo:leftAnchor, constant:5).isActive = true
        label.rightAnchor.constraint(equalTo:rightAnchor, constant:-5).isActive = true
    }
}
