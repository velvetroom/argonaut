import Foundation

public class Profile:Codable {
    public var highQuality = true
    var projects = [String]()
    var rates = [Date]()
    var planed = 0
}
