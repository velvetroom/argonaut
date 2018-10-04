import Foundation

public class Project:Codable {
    public let id = UUID().uuidString
    public var route = [Point]()
    public var origin = Mark()
    public var destination = Mark()
    public var distance = Double()
    public var duration = Double()
}
