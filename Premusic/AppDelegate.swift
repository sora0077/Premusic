//
//  AppDelegate.swift
//  Premusic
//
//  Created by 林達也 on 2017/07/27.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import WindowKit
@testable import PremusicCore
import RealmSwift
import AppleMusicKit

private enum WindowLevel: Int, WindowKit.WindowLevel {
    case main

    static let mainWindowLevel: WindowLevel = .main
}

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let disposeBag = DisposeBag()
    private var notificationToken: NotificationToken?

    private lazy var manager: Manager<WindowLevel> = .init(mainWindow: self.window!)

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        PremusicCore.launch()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()

        let realm = try! Realm()  // swiftlint:disable:this force_try
        notificationToken = realm.objects(Entity.DeveloperToken.self).addNotificationBlock { changes in
            switch changes {
            case .initial(let results), .update(let results, _, _, _):
                if let token = results.first?.token {
                    Session.shared.authorization = .init(developerToken: token)

//                    ChartRepositoryImpl(storefront: "jp").chart().debug().subscribe().disposed(by: self.disposeBag)
                    SearchRepositoryImpl(storefront: "jp").search(term: "初音ミク").debug().subscribe().disposed(by: self.disposeBag)
//                    StorefrontRepositoryImpl().storefronts().debug().subscribe().disposed(by: self.disposeBag)
//                    AlbumRepositoryImpl(storefront: "us").album(with: "310730204").debug().subscribe().disposed(by: self.disposeBag)
                } else {
                    Session.shared.authorization = nil
                }
            case .error(let error):
                break
            }
        }

        if let token = UserDefaults.standard.string(forKey: "DeveloperToken") {
            guard let saved = realm.objects(Entity.DeveloperToken.self).first, token == saved.token else {
                try! realm.write {  // swiftlint:disable:this force_try
                    realm.add(Entity.DeveloperToken(token: token), update: true)
                }
                return true
            }
        }
        return true
    }
}
