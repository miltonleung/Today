//
//  APIRouter.swift
//  Gelato
//
//  Created by Angela on 2017-06-23.
//  Copyright © 2017 Gelato. All rights reserved.
//

import ZenAPI

internal enum APIRouter: URLStringConvertible {
    case today
    case article(url: String)

    var URLString: String {
        let path: String
        switch self {
        case .today:
            path =  "/articles?source=the-new-york-times&sortBy=top"
        case .article(let url):
            return url
        }

        return Environment.baseAPI + path
    }
}
