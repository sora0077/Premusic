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
    config.objectTypes = [
        Entity.StringValue.self,
        Entity.DeveloperToken.self,
        Entity.EditorialNotes.self,
        Entity.Artwork.self,
        Entity.Storefront.self,
        Entity.Storefront.Attributes.self,
        Entity.Genre.self,
        Entity.Genre.Attributes.self,
        Entity.Song.self,
        Entity.Song.Attributes.self,
        Entity.Album.self,
        Entity.Album.Attributes.self,
        Entity.Artist.self,
        Entity.Artist.Attributes.self,
        Cache.StorefrontsCache.self
    ]
    Realm.Configuration.defaultConfiguration = config

    print(config.fileURL?.absoluteString ?? "")
}
