import Foundation
@testable import Argonaut

class MockStorage:StorageService {
    var error:Error?
    var onSaveProfile:(() -> Void)?
    var onSaveProject:(() -> Void)?
    var profile = Profile()
    var project = Project()
    required init() { }
    
    func load() throws -> Profile {
        if let error = self.error {
            throw error
        }
        return profile
    }
    
    func load(project:String) throws -> Project {
        if let error = self.error {
            throw error
        }
        return self.project
    }
    
    func save(profile:Profile) {
        onSaveProfile?()
    }
    
    func save(project:Project) {
        onSaveProject?()
    }
}
