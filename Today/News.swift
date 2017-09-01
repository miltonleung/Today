//
//  News.swift
//  Today
//
//  Created by Milton Leung on 2017-07-26.
//Copyright © 2017 milton. All rights reserved.
//

import Foundation
import Reductio

internal enum ContentStatus {
    case unavailable
    case available(content: String)
}
internal struct News {
    let author: String
    let title: String
    let description: String
    let imageURL: URL
    let url: URL
    let publishedDate: Date

    var status: ContentStatus

    var compressedContent: String?
}

//extension News {
//    var compressedContent: String? {
//        guard case let .available(content) = status else { return nil }
//        Reductio.summarize(text: content, count: 3) { phrases in
//            return phrases.joined()
//        }
//    }
//}

