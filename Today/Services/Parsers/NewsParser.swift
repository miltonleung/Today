//
//  NewsParser.swift
//  Today
//
//  Created by Milton Leung on 2017-07-26.
//  Copyright © 2017 milton. All rights reserved.
//

import Foundation

internal struct NewParser: Parser {
    func parse(_ json: JSON) -> News? {
        guard
            let author = json["author"] as? String,
            let title = json["title"] as? String,
            let description = json["description"] as? String,
            let imageURLString = json["urlToImage"] as? String,
            let imageURL = URL(string: imageURLString),
            let urlString = json["url"] as? String,
            let url = URL(string: urlString),
            let publishedDateString = json["publishedAt"] as? String,
            let publishedDate = Date.date(from: publishedDateString)
            else {
                return nil
        }

        return News(author: author, title: title, description: description, imageURL: imageURL, url: url, publishedDate: publishedDate, status: .unavailable, compressedContent: nil)
    }
}

internal struct NewsParser: Parser {
    func parse(_ array: JSONArray) -> [News]? {
        let parser = NewParser()
        return array.flatMap { parser.parse($0) }
    }
}
