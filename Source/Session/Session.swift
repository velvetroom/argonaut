import Foundation

public class Session {
    var profile:Profile!
    let storage = Factory.makeStorage()
    private let queue = DispatchQueue(label:String(), qos:.background, target:.global(qos:.background))
    
    public func loadProfile(completion:@escaping((Profile) -> Void)) {
        queue.async { [weak self] in
            guard let profile = self?.getProfile() else { return }
            DispatchQueue.main.async { completion(profile) }
        }
    }
    
    func getProfile() -> Profile {
        if profile == nil {
            if let loaded = try? storage.loadProfile() {
                profile = loaded
            } else {
                profile = Profile()
                storage.save(profile:profile)
            }
        }
        return profile
    }
}
