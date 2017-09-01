//
//  TodayWireframe.swift
//  Today
//
//  Created by Milton Leung on 2017-07-26.
//  Copyright © 2017 milton. All rights reserved.
//

import UIKit

internal protocol TodayViewDelegate: class {

}

internal struct TodayWireframe {
    static func viewController(withDelegate delegate: TodayViewDelegate) -> UIViewController {
        let interactor = NewsInteractor()
        let presenter = TodayPresenterImpl(interactor: interactor)
        let vc = TodayViewController(presenter: presenter)

        /*

            presenter.onSelect = { [weak delegate, unowned vc] data in
                delegate?.view(vc, didFinishWith: data)
            }

        */
        return vc
    }
}
