//
//  AppDelegate.swift
//  Today
//
//  Created by Milton Leung on 2017-07-26.
//Copyright © 2017 milton. All rights reserved.
//

import UIKit

@UIApplicationMain
internal class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var mainCoordinator: Coordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow()
        mainCoordinator = MainCoordinator(window: window)
        mainCoordinator.start()
        self.window = window

        return true
    }
}
