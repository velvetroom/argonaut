import UIKit
@testable import Argonaut

class MockShooter:Shooter {
    static var error:Error?
    static var image:UIImage?
    required init(shot:Shot) { }
    
    func make(queue:DispatchQueue, success:@escaping((UIImage) -> Void), fail:@escaping((Error) -> Void)) {
        let staticError = MockShooter.error
        let staticImage = MockShooter.image
        queue.async {
            if let error = staticError {
                fail(error)
            } else if let image = staticImage {
                success(image)
            }
        }
    }
}
