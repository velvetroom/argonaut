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
    override var intrinsicContentSize:CGSize { return CGSize(width:80, height:40) }
    
    private func makeOutlets() {
        let base = UIImageView(image:#imageLiteral(resourceName: "iconType.pdf"))
        base.isUserInteractionEnabled = false
        base.translatesAutoresizingMaskIntoConstraints = false
        base.clipsToBounds = true
        base.contentMode = .center
        addSubview(base)
        
        let walking = UIButton()
        walking.translatesAutoresizingMaskIntoConstraints = false
        walking.setImage(#imageLiteral(resourceName: "iconWalking.pdf").withRenderingMode(.alwaysTemplate), for:[])
        walking.addTarget(self, action:#selector(selectWalking), for:.touchUpInside)
        walking.imageView!.clipsToBounds = true
        walking.imageView!.contentMode = .center
        addSubview(walking)
        self.walking = walking
        
        let driving = UIButton()
        driving.translatesAutoresizingMaskIntoConstraints = false
        driving.setImage(#imageLiteral(resourceName: "iconDriving").withRenderingMode(.alwaysTemplate), for:[])
        driving.addTarget(self, action:#selector(selectDriving), for:.touchUpInside)
        driving.imageView!.clipsToBounds = true
        driving.imageView!.contentMode = .center
        addSubview(driving)
        self.driving = driving
        
        walking.topAnchor.constraint(equalTo:topAnchor).isActive = true
        walking.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        walking.leftAnchor.constraint(equalTo:leftAnchor).isActive = true
        walking.widthAnchor.constraint(equalToConstant:40).isActive = true
        
        driving.topAnchor.constraint(equalTo:topAnchor).isActive = true
        driving.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        driving.rightAnchor.constraint(equalTo:rightAnchor).isActive = true
        driving.widthAnchor.constraint(equalToConstant:40).isActive = true
        
        base.topAnchor.constraint(equalTo:topAnchor).isActive = true
        base.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        base.widthAnchor.constraint(equalToConstant:40).isActive = true
        baseX = base.centerXAnchor.constraint(equalTo:centerXAnchor)
        baseX.isActive = true
    }
    
    @objc private func selectWalking() {
        walking.imageView!.tintColor = .greekBlue
        driving.imageView!.tintColor = .white
        walking.alpha = 1
        driving.alpha = 0.5
        baseX.constant = -20
        map?.type = .walking
        update()
    }
    
    @objc private func selectDriving() {
        walking.imageView!.tintColor = .white
        driving.imageView!.tintColor = .greekBlue
        walking.alpha = 0.5
        driving.alpha = 1
        baseX.constant = 20
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
