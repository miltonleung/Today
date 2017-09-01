import Foundation

internal extension String {
    func localize(withComment comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
