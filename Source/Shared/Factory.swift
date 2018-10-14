import Foundation

public class Factory {
    public static var storage:StorageService.Type!
    static var session:Session!
    
    public class func makeSession() -> Session {
        if session == nil { session = Session() }
        return session
    }
    
    class func makeStorage() -> StorageService { return storage.init() }
    private init() { }
}
