import Foundation

public class Profile:Codable {
    public var highQuality = true
    var projects = [String]()
    var rates = [Date]()
    var planed = 0
    
    init() { }
    
    public required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy:CodingKeys.self)
        try? projects = values.decode([String].self, forKey:.projects)
        try? rates = values.decode([Date].self, forKey:.rates)
        try? planed = values.decode(Int.self, forKey:.planed)
        try? highQuality = values.decode(Bool.self, forKey:.highQuality)
    }
    
    public func encode(to encoder:Encoder) throws {
        var container = encoder.container(keyedBy:CodingKeys.self)
        try container.encode(projects, forKey:.projects)
        try container.encode(rates, forKey:.rates)
        try container.encode(planed, forKey:.planed)
        try container.encode(highQuality, forKey:.highQuality)
    }
    
    private enum CodingKeys:CodingKey {
        case projects
        case rates
        case planed
        case highQuality
    }
}
