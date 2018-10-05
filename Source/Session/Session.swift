import Foundation

public class Session {
    var profile:Profile!
    let storage = Factory.makeStorage()
    private let queue = DispatchQueue(label:String(), qos:.background, target:.global(qos:.background))
    
    public func load(completion:@escaping(([Project]) -> Void)) {
        queue.async { [weak self] in
            guard let items = self?.getProfile().projects.compactMap({ try? self?.storage.load(project:$0) })
                as? [Project] else { return }
            DispatchQueue.main.async { completion(items) }
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
    
    func save() {
        storage.save(profile:profile)
    }
    
    func add(project:Project) {
        getProfile().projects.append(project.id)
        save()
        storage.save(project:project)
    }
}
