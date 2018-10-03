import Foundation

public class Session {
    var profile:Profile!
    let storage = Factory.makeStorage()
    private let queue = DispatchQueue(label:String(), qos:.background, target:.global(qos:.background))
    
    public func load(completion:@escaping((Profile) -> Void)) {
        queue.async { [weak self] in
            guard let profile = self?.getProfile() else { return }
            DispatchQueue.main.async { completion(profile) }
        }
    }
    
    public func load(project:String, completion:@escaping((Project) -> Void)) {
        queue.async { [weak self] in
            guard let item = try! self?.storage.load(project:project) else { return }
            DispatchQueue.main.async { completion(item) }
        }
    }
    
    func getProfile() -> Profile {
        if profile == nil {
            if let loaded = try? storage.load() {
                profile = loaded
            } else {
                profile = Profile()
                storage.save(profile:profile)
            }
        }
        return profile
    }
}
