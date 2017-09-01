//
//  ParameterEncoding.swift
//  Networking
//
//  Created by Francisco Díaz on 2/10/16.
//  Copyright © 2016 Axiom Zen. All rights reserved.
//

import Foundation

public enum ParameterEncoding {
    case URL(encodedInURL: Bool)
    case JSON
    
    private var contentType: (String, String) {
        let type: String
        switch self {
        case .JSON: type = "application/json"
        case .URL(_): type = "application/x-www-form-urlencoded; charset=utf-8"
        }
        return (type, "Content-Type")
    }
    
    func encode(_ urlRequestConvertible: URLRequestConvertible, parameters: JSONDictionary?) {
        urlRequestConvertible.URLRequest.setValue(contentType.0, forHTTPHeaderField: contentType.1)

        guard let parameters = parameters else { return }
        
        switch self {
        case .URL(let encodedInUrl):
            guard let URL = urlRequestConvertible.URLRequest.url,
                let components = URLComponents(url: URL, resolvingAgainstBaseURL: true) else { return }

            var mutableComponents = components
            var queryItems: [URLQueryItem] = []
            for (key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
            }
            mutableComponents.queryItems = queryItems
            
            if encodedInUrl {
                urlRequestConvertible.URLRequest.url = mutableComponents.url
            } else {
                let data = mutableComponents.query?.data(using: String.Encoding.utf8, allowLossyConversion: false)
                urlRequestConvertible.URLRequest.httpBody = data
            }
            
        case .JSON:
            let options = JSONSerialization.WritingOptions()
            let data = try? JSONSerialization.data(withJSONObject: parameters, options: options)
            urlRequestConvertible.URLRequest.httpBody = data
        }
    }
}
