//
//  Error.swift
//  Networking
//
//  Created by Francisco Díaz on 2/10/16.
//  Copyright © 2016 Axiom Zen. All rights reserved.
//

import Foundation

public enum ErrorCode: Int {
    case defaultError = 0
    case malformedURLString
    case statusCodeValidationFailed
    case dataSerializationFailed
    case jsonSerializationFailed
    
    var failureReason: String {
        switch self {
        case .defaultError: return NSLocalizedString("Something went wrong", comment: "")
        case .malformedURLString: return NSLocalizedString("The URL string provided could not be converted to a proper URL.", comment: "")
        case .statusCodeValidationFailed: return NSLocalizedString("Response status code was unacceptable", comment: "")
        case .dataSerializationFailed: return NSLocalizedString("Data could not be serialized. Input data was nil.", comment: "")
        case .jsonSerializationFailed: return NSLocalizedString("JSON could not be serialized. Input data was nil or zero length.", comment: "")
        }
    }
}

public extension NSError {
    private struct Constants {
        static let domain = "co.axiomzen.error"
    }
    
    public convenience init(code: Int, failureReason: String, userInfo: [String: String] = [:]) {
        var info = userInfo
        info[NSLocalizedFailureReasonErrorKey] = failureReason
        self.init(domain: Constants.domain, code: code, userInfo: info)
    }
    
    public convenience init(errorCode: ErrorCode, userInfo: [String: String] = [:]) {
        self.init(code: errorCode.rawValue, failureReason: errorCode.failureReason, userInfo: userInfo)
    }
    
    public static func defaultError() -> NSError {
        return NSError(errorCode: .defaultError)
    }
}
