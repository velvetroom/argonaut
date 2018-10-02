import UIKit

class HomeCellView:UIControl {
    init() {
        super.init(frame:.zero)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .midnightBlue
        layer.cornerRadius = 6
    }
    
    required init?(coder:NSCoder) { return nil }
}
