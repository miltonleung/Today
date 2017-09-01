//
//  MainCoordinator.swift
//  Today
//
//  Created by Milton Leung on 2017-07-26.
//Copyright © 2017 milton. All rights reserved.
//

import UIKit

internal final class MainCoordinator: Coordinator {
    fileprivate var currentCoordinator: Coordinator?

    fileprivate let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        if isUserLoggedIn {
            showContent()
        } else {
            showAuthentication()
        }
        window.makeKeyAndVisible()
    }

    private var isUserLoggedIn: Bool {
        //TODO: Check if the user is logged in
        return true
    }
}

private extension MainCoordinator {
    func showAuthentication() {
        let navigationController = UINavigationController()
        let coordinator = AuthCoordinator(delegate: self, navigationController: navigationController)
        coordinator.start()
        currentCoordinator = coordinator
        window.rootViewController = navigationController
    }

    func showContent() {
        let navigationController = UINavigationController()
        let coordinator = ContentCoordinator(delegate: self, navigationController: navigationController)
        coordinator.start()
        currentCoordinator = coordinator
        window.rootViewController = navigationController
    }
}

extension MainCoordinator: AuthCoordinatorDelegate {
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator) {
        showContent()
    }
}

extension MainCoordinator: ContentCoordinatorDelegate {
    func contentCoordinatorDidFinish(_ coordinator: ContentCoordinator) {
        //TODO: Reset Session Token or delete User if needed
        showAuthentication()
    }
}
