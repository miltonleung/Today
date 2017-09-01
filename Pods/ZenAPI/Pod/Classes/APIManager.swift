//
//  APIManager.swift
//  Networking
//
//  Created by Francisco Díaz on 2/4/16.
//  Copyright © 2016 Francisco Díaz. All rights reserved.
//

import Foundation

public typealias JSONObject = Any
public typealias JSONArray = [JSONObject]
public typealias JSONDictionary = [String: JSONObject]

public struct APIManager {
    private var manager: SessionManager
    private var authToken: String {
        didSet { ensureUnique(sessionToken: authToken) }
    }
    
    public init(authToken: String = "", configuration: APIConfigurationType) {
        self.authToken = authToken
        self.manager = SessionManager(authToken: authToken, configuration: configuration)
    }
    
    /**
     Makes a network request to a provided URLString, and calls a handler upon completion.
     
     - Important: The completion handler is called in a background thread.
     
     - Parameter method: The HTTP method. Acceptable requests can be seen in ZenAPI.RequestMethod.
     - Parameter URLString: The HTTP request URL string.
     - Parameter parameters: The parameters. `nil` by default.
     - Parameter encoding: The parameter encodings. `.JSON` by default.
     - Parameter validStatusCode: The valid status code. 200..<300 by default.
     - Parameter parser: Block for converting from NSData to the appropriate Result type; NSJSONSerialization by default.
     - Parameter completion: The completion handler to call when the request is complete.
        - Successful result: Passes the JSON retrieved.
        - Failed result: Passes an NSError from `ZenAPI.Error`.
     */
    public func request<T>(method: RequestMethod, URLString: URLStringConvertible, parameters: JSONDictionary? = nil, encoding: ParameterEncoding = .JSON, validStatusCode: Range<Int> = 200..<300, parser: @escaping ((Data) -> Result<T, NSError>) = toJSON, completion: @escaping (Result<T, NSError>) -> Void) {
        manager.fetchData(method, URLString: URLString, parameters: parameters, encoding: encoding, validStatusCode: validStatusCode) { result in
            completion(result.flatMap(parser))
        }
    }
    
    /**
     Downloads data from a provided URLString, and calls a handler upon completion.
     
     - Important: The completion handler is called in a background thread.
     
     - Parameter URLString: The HTTP request URL string.
     - Parameter completion: The completion handler to call when the request is complete.
        - Successful result: Passes the NSData retrieved.
        - Failed result: Passes an NSError from `ZenAPI.Error`.
     */
    public func downloadData(withURLString URLString: URLStringConvertible, completion: @escaping (Result<Data, NSError>) -> Void) {
        manager.downloadData(URLString, completion: completion)
    }
    
    private mutating func ensureUnique(sessionToken: String? = nil) {
        if !isKnownUniquelyReferenced(&manager) {
            manager = manager.clone()
        }
    }
}

public func toJSON<T>(_ data: Data) -> Result<T, NSError> {
    return Result {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? T else {
                throw NSError(errorCode: .jsonSerializationFailed)
            }
            return json
        } catch {
            throw error
        }
    }
}

// MARK: - API Configuration

public protocol APIConfigurationType {
    var timeoutInterval: TimeInterval { get }
    func additionalHTTPHeaders(withAuthToken authToken: String?) -> [String: String]
}

public extension APIConfigurationType {
    var timeoutInterval: TimeInterval { return 30 }
}

public struct DefaultAPIConfiguration: APIConfigurationType {
    private struct Constants {
        static let authTokenHeaderField = "X-Auth-Token"
    }
    
    public func additionalHTTPHeaders(withAuthToken authToken: String? = nil) -> [String: String] {
        var headers: [String: String] = [:]
        headers[Constants.authTokenHeaderField] = authToken
        return headers
    }
}

// MARK: - API Manager

private final class SessionManager {
    let session: URLSession
    
    required init(session: URLSession) {
        self.session = session
    }
    
    convenience init(authToken: String? = nil, configuration: APIConfigurationType) {
        let urlConfiguration = URLSessionConfiguration.default
        urlConfiguration.timeoutIntervalForRequest = configuration.timeoutInterval
        urlConfiguration.httpAdditionalHeaders = configuration.additionalHTTPHeaders(withAuthToken: authToken)
        self.init(session: URLSession(configuration: urlConfiguration))
    }
    
    func fetchData(_ method: RequestMethod, URLString: URLStringConvertible, parameters: JSONDictionary?, encoding: ParameterEncoding, validStatusCode: Range<Int>, completion: @escaping (Result<Data, NSError>) -> Void) {
        guard let request = DataRequest(method: method, URLString: URLString, parameters: parameters, encoding: encoding)?.URLRequest else {
            completion( .failure(NSError(errorCode: .malformedURLString)) )
            return
        }
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            completion( Result {
                if let error = error { throw error }
                guard let data = data else { throw NSError(errorCode: .dataSerializationFailed) }
                guard let response = response as? HTTPURLResponse else { throw NSError(errorCode: .statusCodeValidationFailed) }
                guard validStatusCode ~= response.statusCode else {
                    throw NSError(domain: NSURLErrorDomain, code: response.statusCode, userInfo: ["HTTPURLResponse": response])
                }
                return data
                })
            }.resume()
    }
    
    func downloadData(_ URLString: URLStringConvertible, completion: @escaping (Result<Data, NSError>) -> Void) {
        guard let downloadRequest = DownloadRequest(URLString: URLString)?.URLRequest else {
            completion( .failure(NSError(errorCode: .malformedURLString)) )
            return
        }
        session.downloadTask(with: downloadRequest as URLRequest) { (location, response, error) in
            completion( Result {
                if let error = error { throw error }
                guard let location = location,
                    let data = try? Data(contentsOf: location) else { throw NSError(errorCode: .dataSerializationFailed) }
                return data
                })
            }.resume()
    }
    
    func clone() -> SessionManager {
        // If we copy the NSURLSession instance, we'd get the same object. If we copy the configuration, we get a copy instead.
        let configuration = session.configuration.copy() as! URLSessionConfiguration
        return SessionManager(session: URLSession(configuration: configuration))
    }
}
