//
//  NewYorkTimesParser.swift
//  Today
//
//  Created by Milton Leung on 2017-07-28.
//  Copyright © 2017 milton. All rights reserved.
//

import Kanna

internal struct NewYorkTimesParser {
    func parse(string: String) -> String {
        guard let doc = HTML(html: string, encoding: .utf8) else { return "" }
        var article: String = ""
        for paragraph in doc.css("p.story-body-text") {
            if let text = paragraph.text {
                article += text
            }
        }
        return article
    }
}
