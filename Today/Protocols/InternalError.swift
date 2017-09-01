import Foundation

internal protocol InternalError: Error {
    var domain: String { get }
    var code: Int { get }
    var localizedDescription: String { get }
    var localizedFailureReason: String { get }
    var error: NSError { get }
    func error(additionalUserInfo userInfo: [String: String]?) -> NSError
}

internal extension InternalError {
    var domain: String {
        return NSError.Default.domain
    }

    var localizedDescription: String {
        return NSError.Default.description
    }

    var localizedFailureReason: String {
        return NSError.Default.description
    }

    var error: NSError {
        return NSError(error: self)
    }

    func error(additionalUserInfo userInfo: [String: String]?) -> NSError {
        return NSError(error: self, additionalUserInfo: userInfo)
    }
}

internal extension InternalError where Self: RawRepresentable, Self.RawValue == Int {
    var code: Int {
        return rawValue
    }
}

internal extension NSError {
    struct Default {
        static let domain = "co.axiomzen"
        static let description = NSLocalizedString("There was a problem. Please try again later.", comment: "Default error")
    }

    fileprivate convenience init(error: InternalError, additionalUserInfo: [String: String]? = nil) {
        var userInfo: [String: String] = [
            NSLocalizedDescriptionKey: error.localizedDescription,
            NSLocalizedFailureReasonErrorKey: error.localizedFailureReason
        ]
        if let additionalUserInfo = additionalUserInfo {
            for (key, value) in additionalUserInfo {
                userInfo[key] = value
            }
        }

        self.init(domain: error.domain,
                  code: error.code,
                  userInfo: userInfo)
    }
}

internal enum ParsingError: Int, InternalError {
    case standard

    var domain: String {
        return NSError.Default.domain + ".parsing"
    }

    var localizedFailureReason: String {
        switch self {
        case .standard: return NSLocalizedString("There was a problem while parsing.", comment: "")
        }
    }
}
