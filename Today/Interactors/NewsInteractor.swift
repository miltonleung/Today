//
//  NewsInteractor.swift
//  Today
//
//  Created by Milton Leung on 2017-07-26.
//Copyright © 2017 milton. All rights reserved.
//

import Foundation
import BrightFutures

internal protocol FetchNewsInteractor: class {
    func fetchNews() -> Future<[News], NSError>
    func compress(article: String) -> Future<String, NSError>
}

internal final class NewsInteractor {
    fileprivate let dataManager: NewsDataManager

    init(dataManager: NewsDataManager = ModelDataManager.default()) {
        self.dataManager = dataManager
    }
}

extension NewsInteractor: FetchNewsInteractor {
    func fetchNews() -> Future<[News], NSError> {
        return dataManager.fetchNews()
    }

    func compress(article: String) -> Future<String, NSError> {
        return dataManager.compressArticles(string: article)
    }
}
