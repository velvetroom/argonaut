import UIKit

class LoadingView:UIView {
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        isUserInteractionEnabled = false
        backgroundColor = .clear
        
        let path = UIBezierPath()
        path.addArc(withCenter:CGPoint(x:75, y:75), radius:25, startAngle:0.001, endAngle:0, clockwise:true)
        
        let pulse = CAShapeLayer()
        pulse.fillColor = UIColor.greekBlue.cgColor
        pulse.path = path.cgPath
        pulse.frame = CGRect(x:0, y:0, width:150, height:150)
        layer.addSublayer(pulse)
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animateRadiusFade(), animateAlpha()]
        groupAnimation.duration = 3
        groupAnimation.repeatCount = .infinity
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards
        pulse.add(groupAnimation, forKey:"animation")
        
        let icon = UIImageView(image:#imageLiteral(resourceName: "iconLogo.pdf"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.clipsToBounds = true
        icon.contentMode = .center
        addSubview(icon)
        
        icon.widthAnchor.constraint(equalToConstant:75).isActive = true
        icon.heightAnchor.constraint(equalToConstant:75).isActive = true
        icon.centerXAnchor.constraint(equalTo:centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo:centerYAnchor).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    override var intrinsicContentSize:CGSize { return CGSize(width:150, height:150) }
    
    private func animateRadiusFade() -> CAAnimation {
        let animation = CABasicAnimation(keyPath:"transform.scale")
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(controlPoints:0.4, 0, 0.2, 1)
        animation.fromValue = 1
        animation.toValue = 2.2
        animation.beginTime = 0
        return animation
    }
    
    private func animateAlpha() -> CAAnimation {
        let animation = CABasicAnimation(keyPath:"opacity")
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(controlPoints:0.4, 0, 0.2, 1)
        animation.fromValue = 1
        animation.toValue = 0
        animation.beginTime = 0
        return animation
    }
}
