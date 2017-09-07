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

private extension EntityType where Self: Object, Attributes: Object, Relations: Object {
    static var classes: [Object.Type] { return [Self.self, Attributes.self, Relations.self] }
}

private extension Array where Iterator.Element: Sequence {
    var flatten: [Iterator.Element.Iterator.Element] {
        return flatMap { $0 }
    }
}

public func launch() {
    var config = Realm.Configuration.defaultConfiguration
    config.deleteRealmIfMigrationNeeded = true
    let objectTypes = [
        Cache.RequestObject.self,
        Cache.StorefrontsCache.self,
        Cache.SongCache.self,
        Entity.Chart.ChartSongs.self,
        Entity.Search.SearchObject.self,
        Entity.Search.SearchSongs.self,
        Entity.Search.SearchAlbums.self,
        Entity.Search.SearchArtists.self,
        Entity.StringValue.self,
        Entity.DeveloperToken.self,
        Entity.EditorialNotes.self,
        Entity.Artwork.self
    ]
    config.objectTypes = objectTypes + [
        Entity.Storefront.classes,
        Entity.Genre.classes,
        Entity.Song.classes,
        Entity.MusicVideo.classes,
        Entity.Album.classes,
        Entity.Artist.classes
        ].flatten
    Realm.Configuration.defaultConfiguration = config

    let realm = try? Realm()

    let path = realm?.configuration.fileURL?.absoluteString ?? config.fileURL?.absoluteString ?? ""
    print("open " + path.replacingOccurrences(of: "file://", with: ""))
}
