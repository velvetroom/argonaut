import Foundation

public class Project:Codable {
    public var id = String()
    public var route = [Point]()
    public var origin = Mark()
    public var destination = Mark()
    public var distance = Double()
    public var duration = Double()
}
