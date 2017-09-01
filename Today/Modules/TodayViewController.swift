//
//  TodayViewController.swift
//  Today
//
//  Created by Milton Leung on 2017-07-26.
//  Copyright © 2017 milton. All rights reserved.
//

import UIKit
import Reductio

internal final class TodayViewController: UIViewController {

    @IBOutlet fileprivate weak var tableView: UITableView! {
        didSet {
            tableView.register(TodayCell.self)
        }
    }

    fileprivate let presenter: TodayPresenter

    init(presenter: TodayPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = presenter.title
        presenter.onNewsUpdate = updateViews
        presenter.fetchNews()

        
//        let starttime = CFAbsoluteTimeGetCurrent()
//        Reductio.summarize(text: string, count: 3) { phrases in
////            print(phrases)
//            print(CFAbsoluteTimeGetCurrent() - starttime)
//        }
    }

    func updateViews() {
        tableView.reloadData()
    }
}

extension TodayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TodayCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: presenter.itemPresenter(at: indexPath))
        cell.selectionStyle = .none
        return cell
    }
}

extension TodayViewController: UITableViewDelegate {
//        presenter.selectItem(at: indexPath)

}

