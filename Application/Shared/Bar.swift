import UIKit

class Bar:UIView {
    init(_ title:String, left:[Button] = [], right:[Button] = []) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.textColor = .white
        label.font = .systemFont(ofSize:16, weight:.bold)
        label.text = title
        label.textAlignment = .center
        addSubview(label)
        
        label.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        label.topAnchor.constraint(equalTo:topAnchor).isActive = true
        
        var anchor = rightAnchor
        right.forEach { button in
            addSubview(button)
            button.topAnchor.constraint(equalTo:topAnchor).isActive = true
            button.rightAnchor.constraint(equalTo:anchor).isActive = true
            anchor = button.leftAnchor
        }
        anchor = leftAnchor
        left.forEach { button in
            addSubview(button)
            button.topAnchor.constraint(equalTo:topAnchor).isActive = true
            button.leftAnchor.constraint(equalTo:anchor).isActive = true
            anchor = button.rightAnchor
        }
    }
    
    required init?(coder:NSCoder) { return nil }
    override var intrinsicContentSize:CGSize { return CGSize(width:UIView.noIntrinsicMetric, height:56) }
}
