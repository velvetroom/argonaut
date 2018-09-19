import UIKit
@testable import Argonaut

class MockShooter:Shooter {
    static var error:Error?
    static var image:UIImage?
    required init(shot:Shot) { }
    
    func make(queue:DispatchQueue, success:@escaping((UIImage) -> Void), fail:@escaping((Error) -> Void)) {
        if let error = MockShooter.error {
            fail(error)
        } else if let image = MockShooter.image {
            success(image)
        }
    }
}
