//
//  PremusicCore.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/08/16.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift
import APIKit
import AppleMusicKit
@_exported import RxSwift

public func launch() {
    var config = Realm.Configuration.defaultConfiguration
    config.deleteRealmIfMigrationNeeded = true
    Realm.Configuration.defaultConfiguration = config

    print(config.fileURL?.absoluteString ?? "")
}
