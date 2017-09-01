//
//  ModelDataManager.swift
//  Gelato
//
//  Created by Angela on 2017-05-24.
//  Copyright © 2017 Gelato. All rights reserved.
//

import BrightFutures
import Reductio

internal final class ModelDataManager {
    fileprivate struct Constants {
        static let sentenceCompression = 3
    }
    fileprivate let API: API

    init(API: API) {
        self.API = API
    }

    static func `default`() -> ModelDataManager {
        let API = APIClient()
        return ModelDataManager(API: API)
    }
}

internal protocol NewsDataManager: class {
    func fetchNews() -> Future<[News], NSError>
    func fetchNewsContent(news: [News]) -> Future<[News], NSError>
    func compressArticles(string: String) -> Future<String, NSError>
}

extension ModelDataManager: NewsDataManager {
    func fetchNews() -> Future<[News], NSError> {
        return API.times().flatMap({ (result) -> Future<[News], NSError> in
            guard let articles = result["articles"] as? JSONArray else { return Future(error: ParsingError.standard.error) }
            return self.fetchNewsContent(news: NewsParser().parse(articles) ?? [])
            //            return NewsParser().parse(articles)
        })
    }

    func fetchNewsContent(news: [News]) -> Future<[News], NSError> {
        return Future { complete in
            var news = news
            let newsSequence = news.map { news in
                return API.fetchArticle(router: APIRouter.article(url: news.url.absoluteString))
            }
            newsSequence.sequence().onSuccess { articles in
                let articles = articles
                    .map { NewYorkTimesParser().parse(string: $0) }
                for (index, value) in news.enumerated() {
                    news[index].status = ContentStatus.available(content: articles[index])
                }

                let compressNewsSequence: [Future<String, NSError>] = news.flatMap { news in
                    guard case let .available(content) = news.status,
                        !content.isEmpty else { return nil }
                    return self.compressArticles(string: content)
                }

                compressNewsSequence.sequence().onSuccess { compressedNews in
                    for (index, value) in news.enumerated() {
                        news[index].compressedContent = compressedNews[index]
                    }

                    complete(.success(news))
                    }
                    .onFailure { error in
                        print(error)
                    }
            }
            .onFailure { error in
                print(error)
                complete(.failure(error))
            }
        }
    }

    func compressArticles(string: String) -> Future<String, NSError> {
        return Future { complete in
            Reductio.summarize(text: string, count: Constants.sentenceCompression) { result in
                complete(.success(result.joined()))
            }
        }
    }
}
