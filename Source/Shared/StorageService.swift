import Foundation

public protocol StorageService {
    func load() throws -> Profile
    func load(project:String) throws -> Project
    func save(profile:Profile)
    init()
}
