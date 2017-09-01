//
//  API.swift
//  Gelato
//
//  Created by Angela on 2017-06-23.
//  Copyright © 2017 Gelato. All rights reserved.
//

//
//  API.swift
//  PrettyGoodNews
//
//  Created by Angela on 2017-01-05.
//  Copyright © 2017 Axiom Zen. All rights reserved.
//

import BrightFutures
import ZenAPI

internal typealias API = UnauthenticatedAPI & AuthenticatedAPI

internal protocol UnauthenticatedAPI {
    func times() -> Future<JSON, NSError>
    func fetchArticle(router: APIRouter) -> Future<String, NSError> 
}

internal protocol AuthenticatedAPI { }

internal final class APIClient {
    fileprivate let manager: APIManager

    init() {
        manager = APIManager(configuration: APIConfiguration())
    }
}

internal extension APIClient {
    fileprivate func request<T>(method: RequestMethod,
                             URLString: APIRouter,
                             parameters: [String: Any]? = nil,
                             encoding: ParameterEncoding = .JSON) -> Future<T, NSError> {

        return Future { complete in
            manager.request(method: method,
                            URLString: URLString,
                            parameters: parameters,
                            encoding: encoding) { (result: ZenAPI.Result<T, NSError>) in
                                switch result {
                                case .success(let value):
                                    complete(.success(value))
                                case .failure(let error):
                                    complete(.failure(error))
                                }
            }
        }
    }

    fileprivate func requestString(method: RequestMethod,
                                URLString: APIRouter,
                                parameters: [String: Any]? = nil,
                                encoding: ParameterEncoding = .JSON) -> Future<String, NSError> {
        return Future { complete in
            manager.downloadData(withURLString: URLString) { (result: Result<Data, NSError>) in
                switch result {
                case .success(let value):

                    complete(.success(String(data: value, encoding: .utf8) ?? ""))
                case .failure(let error):
                    complete(.failure(error))
                }
            }
        }
    }
}

// MARK: - API Configuration
private struct APIConfiguration: APIConfigurationType {
    struct Constants {
        static let APITokenKey = "x-api-key"
        static let TimeoutInterval: TimeInterval = 30
    }

    var timeoutInterval: TimeInterval { return Constants.TimeoutInterval }

    func additionalHTTPHeaders(withAuthToken authToken: String? = nil) -> [String: String] {
        var headers: [String: String] = [:]
        headers[Constants.APITokenKey] = Environment.apiToken
        return headers
    }
}

// MARK: - UnauthenticatedAPI
extension APIClient: UnauthenticatedAPI {
    func times() -> Future<JSON, NSError> {
        return request(method: .GET,
                       URLString: .today)
    }

    func fetchArticle(router: APIRouter) -> Future<String, NSError> {
        return requestString(method: .GET,
                       URLString: router)
    }
}

// MARK: - AuthenticatedAPI
extension APIClient: AuthenticatedAPI { }
