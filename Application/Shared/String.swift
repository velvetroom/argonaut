import Foundation

extension String {
    static func localized(_ key:String) -> String { return NSLocalizedString(key, comment:String()) }
}
