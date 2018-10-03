import Foundation

public protocol StorageService {
    func loadProfile() throws -> Profile
    func save(profile:Profile)
    init()
}
