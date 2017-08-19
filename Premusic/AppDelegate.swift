//
//  AppDelegate.swift
//  Premusic
//
//  Created by 林達也 on 2017/07/27.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import WindowKit
import PremusicCore

private enum WindowLevel: Int, WindowKit.WindowLevel {
    case main

    static let mainWindowLevel: WindowLevel = .main
}

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var manager: Manager<WindowLevel> = .init(mainWindow: self.window!)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        PremusicCore.launch()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
