import UIKit

protocol Shooter:AnyObject {
    init(shot:Shot)
    func make(queue:DispatchQueue, success:@escaping((UIImage) -> Void), fail:@escaping((Error) -> Void))
}
