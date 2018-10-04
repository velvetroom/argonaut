import Foundation

public class Project:Codable {
    public let id = UUID()
    public var route = [Point]()
    public var origin = Point()
    public var destination = Point()
    public var distance = Double()
    public var duration = Double()
}
