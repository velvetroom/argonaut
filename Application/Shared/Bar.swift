import UIKit

class Bar:UIView {
    private(set) weak var border:UIView!
    
    init(_ title:String, left:[Button] = [], right:[Button] = []) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = .midnightBlue
        border.isUserInteractionEnabled = false
        addSubview(border)
        self.border = border
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.textColor = .white
        label.font = .systemFont(ofSize:14, weight:.bold)
        label.text = title
        label.textAlignment = .center
        addSubview(label)
        
        border.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        border.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant:1).isActive = true
        
        label.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
        
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
    override var intrinsicContentSize:CGSize { return CGSize(width:UIView.noIntrinsicMetric, height:60) }
}
