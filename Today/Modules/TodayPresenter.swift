//
//  TodayPresenter.swift
//  Today
//
//  Created by Milton Leung on 2017-07-26.
//  Copyright © 2017 milton. All rights reserved.
//

import Foundation

internal protocol TodayPresenter: class {
    var numberOfItems: Int { get }
    func itemPresenter(at indexPath: IndexPath) -> TodayCellPresenter
    func selectItem(at indexPath: IndexPath)
    func fetchNews()
    var onNewsUpdate: (() -> Void)? { get set }
    var title: String { get }
}

internal final class TodayPresenterImpl {
    let title: String = "Today"
    fileprivate var news: [News] = []

    fileprivate let interactor: FetchNewsInteractor

    init(interactor: FetchNewsInteractor) {
        self.interactor = interactor
    }

    var onNewsUpdate: (() -> Void)?
}

extension TodayPresenterImpl: TodayPresenter {
    var numberOfItems: Int {
        return news.count
    }

    func itemPresenter(at indexPath: IndexPath) -> TodayCellPresenter {
        return TodayCellPresenterImpl(news: news[indexPath.item])
    }

    func selectItem(at indexPath: IndexPath) {
        //TODO: Handle selected item
    }

    func fetchNews() {
        interactor.fetchNews()
            .onSuccess { [weak self] news in
                guard let `self` = self else { return }
                self.news = news
                self.onNewsUpdate?()
            }
            .onFailure { error in
                print(error)
        }
    }
}
