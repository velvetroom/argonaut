import Foundation

public class Project:Codable {
    public let id = UUID()
    public var distance = Double()
    public var duration = Double()
    public var route = [Point]()
}

public struct Point:Codable {
    let latitude:Double
    let longitude:Double
}
