//
//  TodayCellPresenter.swift
//  Today
//
//  Created by Milton Leung on 2017-07-26.
//  Copyright © 2017 milton. All rights reserved.
//

import Foundation

internal protocol TodayCellPresenter: class {
    var title: String { get }
    var description: String { get }
    var content: String { get }
}

internal final class TodayCellPresenterImpl {
    fileprivate let news: News

    init(news: News) {
        self.news = news
    }
}

extension TodayCellPresenterImpl: TodayCellPresenter {
    var title: String {
        return news.title
    }

    var description: String {
        return news.description
    }

    var content: String {
        guard case let .available(content) = news.status else { return news.description }
        return news.compressedContent ?? content
    }
}
