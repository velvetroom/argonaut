import UIKit

class Bar:UIView {
    init(title:String) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = .midnightBlue
        border.isUserInteractionEnabled = false
        addSubview(border)
        
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
    }
    
    required init?(coder:NSCoder) { return nil }
    override var intrinsicContentSize:CGSize { return CGSize(width:UIView.noIntrinsicMetric, height:60) }
}
