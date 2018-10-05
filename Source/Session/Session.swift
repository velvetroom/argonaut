import Foundation

public class Session {
    let storage = Factory.makeStorage()
    private var cachedProfile:Profile!
    private let queue = DispatchQueue(label:String(), qos:.background, target:.global(qos:.background))
    
    public func load(completion:@escaping(([Project]) -> Void)) {
        queue.async { [weak self] in
            guard let items = self?.profile().projects.compactMap({ try? self?.storage.load(project:$0) })
                as? [Project] else { return }
            DispatchQueue.main.async { completion(items) }
        }
    }
    
    public func rate() -> Bool {
        var rating = false
        if profile().planed > 1 {
            if let last = profile().rates.last,
                let months = Calendar.current.dateComponents([.month], from:last, to:Date()).month {
                rating = months < -2
            } else {
                rating = true
            }
        }
        if rating {
            profile().rates.append(Date())
        }
        return rating
    }
    
    func profile() -> Profile {
        if cachedProfile == nil {
            if let loaded = try? storage.load() {
                cachedProfile = loaded
            } else {
                cachedProfile = Profile()
                storage.save(profile:cachedProfile)
            }
        }
        return cachedProfile
    }
    
    func save() {
        storage.save(profile:cachedProfile)
    }
    
    func add(project:Project) {
        profile().projects.append(project.id)
        profile().planed += 1
        save()
        storage.save(project:project)
    }
}
