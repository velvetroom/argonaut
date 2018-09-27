import UIKit

class PlanTypeView:UIView {
    weak var map:PlanMapView?
    private weak var walking:UIButton!
    private weak var driving:UIButton!
    private weak var baseX:NSLayoutConstraint!
    
    init() {
        super.init(frame:.zero)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        makeOutlets()
        selectWalking()
    }
    
    required init?(coder:NSCoder) { return nil }
    override var intrinsicContentSize:CGSize { return CGSize(width:70, height:32) }
    
    private func makeOutlets() {
        let base = UIView()
        base.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.2431372549, blue: 0.4941176471, alpha: 1)
        base.isUserInteractionEnabled = false
        base.translatesAutoresizingMaskIntoConstraints = false
        base.clipsToBounds = true
        base.layer.cornerRadius = 16
        addSubview(base)
        
        let walking = UIButton()
        walking.translatesAutoresizingMaskIntoConstraints = false
        walking.setImage(#imageLiteral(resourceName: "iconWalking.pdf"), for:[])
        walking.addTarget(self, action:#selector(selectWalking), for:.touchUpInside)
        walking.imageView!.clipsToBounds = true
        walking.imageView!.contentMode = .center
        addSubview(walking)
        self.walking = walking
        
        let driving = UIButton()
        driving.translatesAutoresizingMaskIntoConstraints = false
        driving.setImage(#imageLiteral(resourceName: "iconDriving"), for:[])
        driving.addTarget(self, action:#selector(selectDriving), for:.touchUpInside)
        driving.imageView!.clipsToBounds = true
        driving.imageView!.contentMode = .center
        addSubview(driving)
        self.driving = driving
        
        walking.topAnchor.constraint(equalTo:topAnchor).isActive = true
        walking.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        walking.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        walking.widthAnchor.constraint(equalToConstant:32).isActive = true
        
        driving.topAnchor.constraint(equalTo:topAnchor).isActive = true
        driving.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        driving.leftAnchor.constraint(equalTo:walking.rightAnchor, constant:6).isActive = true
        driving.widthAnchor.constraint(equalToConstant:32).isActive = true
        
        base.topAnchor.constraint(equalTo:topAnchor).isActive = true
        base.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        base.widthAnchor.constraint(equalToConstant:32).isActive = true
        baseX = base.centerXAnchor.constraint(equalTo:centerXAnchor)
        baseX.isActive = true
    }
    
    @objc private func selectWalking() {
        walking.alpha = 1
        driving.alpha = 0.35
        baseX.constant = -19
        map?.type = .walking
        update()
    }
    
    @objc private func selectDriving() {
        walking.alpha = 0.35
        driving.alpha = 1
        baseX.constant = 19
        map?.type = .automobile
        update()
    }
    
    private func update() {
        UIView.animate(withDuration:0.3, animations: { [weak self] in
            self?.layoutIfNeeded()
        }) { [weak self] _ in
            self?.map?.updateRoute()
        }
    }
}
