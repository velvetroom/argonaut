import UIKit

class PlanTypesView:UIView {
    private weak var walking:PlanTypeView!
    private weak var driving:PlanTypeView!
    
    init() {
        super.init(frame:.zero)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        makeOutlets()
    }
    
    required init?(coder:NSCoder) { return nil }
    override var intrinsicContentSize:CGSize { return CGSize(width:70, height:32) }
    
    private func makeOutlets() {
        let walking = PlanTypeView()
        walking.image.image = #imageLiteral(resourceName: "iconWalking.pdf")
        walking.control.addTarget(self, action:#selector(selectWalking), for:.touchUpInside)
        walking.selected()
        addSubview(walking)
        self.walking = walking
        
        let driving = PlanTypeView()
        driving.image.image = #imageLiteral(resourceName: "iconDriving")
        driving.control.addTarget(self, action:#selector(selectDriving), for:.touchUpInside)
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
    }
    
    @objc private func selectWalking() {
        walking.selected()
        driving.notSelected()
    }
    
    @objc private func selectDriving() {
        walking.notSelected()
        driving.selected()
    }
}
