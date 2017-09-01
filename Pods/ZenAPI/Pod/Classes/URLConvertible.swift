//
//  URLConvertible.swift
//  Networking
//
//  Created by Francisco Díaz on 2/4/16.
//  Copyright © 2016 Axiom Zen. All rights reserved.
//

import Foundation

public enum RequestMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

public protocol URLStringConvertible {
    var URLString: String { get }
}

extension URL: URLStringConvertible {
    public var URLString: String {
        return absoluteString 
    }
}

internal protocol URLRequestConvertible {
    var URLRequest: NSMutableURLRequest { get }
}

internal struct DataRequest: URLRequestConvertible {
    let URLRequest: NSMutableURLRequest
    
    init?(method: RequestMethod, URLString: URLStringConvertible, parameters: JSONDictionary?, encoding: ParameterEncoding) {
        guard let URL = URL(string: URLString.URLString) else { return nil }
        URLRequest = NSMutableURLRequest(url: URL)
        URLRequest.httpMethod = method.rawValue
        encoding.encode(self, parameters: parameters)
    }
}

internal struct DownloadRequest: URLRequestConvertible {
    let URLRequest: NSMutableURLRequest
    
    init?(URLString: URLStringConvertible) {
        guard let URL = URL(string: URLString.URLString) else { return nil }
        URLRequest = NSMutableURLRequest(url: URL)
    }
}
