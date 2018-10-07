import UIKit

class ButtonBlue:UIButton {
    init(title:String) {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = 6
        backgroundColor = .greekBlue
        setTitleColor(.black, for:.normal)
        setTitleColor(UIColor(white:0, alpha:0.2), for:.highlighted)
        setTitle(title, for:[])
        titleLabel!.font = .systemFont(ofSize:14, weight:.light)
    }
    
    required init?(coder:NSCoder) { return nil }
    override var intrinsicContentSize:CGSize { return CGSize(width:120, height:32) }
}
