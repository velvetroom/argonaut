import Foundation
@testable import Argonaut

class MockStorage:StorageService {
    var error:Error?
    var onSaveProfile:(() -> Void)?
    var profile = Profile()
    required init() { }
    
    func loadProfile() throws -> Profile {
        if let error = self.error {
            throw error
        }
        return profile
    }
    
    func save(profile:Profile) {
        onSaveProfile?()
    }
}
