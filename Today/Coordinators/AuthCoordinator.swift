//
//  AuthCoordinator.swift
//  Today
//
//  Created by Milton Leung on 2017-07-26.
//Copyright © 2017 milton. All rights reserved.
//

import UIKit

internal protocol AuthCoordinatorDelegate: class {
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator)
}

internal final class AuthCoordinator: Coordinator {
    fileprivate let navigationController: UINavigationController
    fileprivate weak var delegate: AuthCoordinatorDelegate?

    init(delegate: AuthCoordinatorDelegate, navigationController: UINavigationController) {
        self.delegate = delegate
        self.navigationController = navigationController
    }

    func start() {
        //TODO: Load the Login View Controller
        navigationController.viewControllers = [UIViewController()]
    }
}
