internal enum Environment {
    case staging
    case production

    #if DEBUG
    fileprivate static let current: Environment = .staging
    #else
    fileprivate static let current: Environment = .production
    #endif
}

internal extension Environment {
    static var baseAPI: String {
        switch Environment.current {
        case .staging: return "https://newsapi.org/v1"
        case .production: return "https://newsapi.org/v1"
        }
    }

    static var apiToken: String {
        switch Environment.current {
        case .staging: return "fa3b7ea95a604e62b3ef9f986daf4092"
        case .production: return "fa3b7ea95a604e62b3ef9f986daf4092"
        }
    }
}
