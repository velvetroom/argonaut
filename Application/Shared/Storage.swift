import CodableHero
import Argonaut

class Storage:StorageService {
    private let hero = Hero()
    required init() { }
    
    func load() throws -> Profile {
        return try hero.load(path:"Profile.argonaut")
    }
    
    func load(project:String) throws -> Project {
        return try hero.load(path:project + ".argonaut")
    }
    
    func save(profile:Profile) {
        try? hero.save(model:profile, path:"Profile.argonaut")
    }
    
    func save(project:Project) {
        try? hero.save(model:project, path:project.id + ".argonaut")
    }
    
    func delete(project:Project) {
        let url = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask).last!.appendingPathComponent(
            project.id + ".argonaut")
        try! FileManager.default.removeItem(at:url)
    }
}
