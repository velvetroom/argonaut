import Foundation

public protocol StorageService {
    func load() throws -> Profile
    func load(project:String) throws -> Project
    func save(profile:Profile)
    func save(project:Project)
    func delete(project:Project)
    init()
}
