//
//  ContentCoordinator.swift
//  Today
//
//  Created by Milton Leung on 2017-07-26.
//Copyright © 2017 milton. All rights reserved.
//

import UIKit

internal protocol ContentCoordinatorDelegate: class {
    func contentCoordinatorDidFinish(_ coordinator: ContentCoordinator)
}

internal final class ContentCoordinator: Coordinator {
    fileprivate let navigationController: UINavigationController
    fileprivate weak var delegate: ContentCoordinatorDelegate?

    init(delegate: ContentCoordinatorDelegate, navigationController: UINavigationController) {
        self.delegate = delegate
        self.navigationController = navigationController
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController.navigationBar.shadowImage = UIImage()
        self.navigationController.navigationBar.isTranslucent = true
    }

    func start() {
        let todayVC = TodayWireframe.viewController(withDelegate: self)
        navigationController.viewControllers = [todayVC]
    }
}

extension ContentCoordinator: TodayViewDelegate {

}
