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
@_exported import class RealmSwift.ThreadSafeReference
@_exported import class RealmSwift.Results
@_exported import class RealmSwift.List

public protocol PremusicRealmObjectType {}
extension Object: PremusicRealmObjectType {}
public extension PremusicRealmObjectType where Self: Object {
    typealias Ref = ThreadSafeReference<Self>
    var ref: Ref { return .init(to: self) }
}

extension RealmCollection {
    typealias Changes = (Self, Observable<RealmCollectionChange<Self>>)
}

private extension EntityType where Self: Object, Attributes: Object, Relations: Object {
    static var classes: [Object.Type] { return [Self.self, Attributes.self, Relations.self] }
}

private extension Array where Iterator.Element: Sequence {
    var flatten: [Iterator.Element.Iterator.Element] {
        return flatMap { $0 }
    }
}

private func objectTypes() -> [Object.Type] {
    let objectTypes = [
        Cache.RequestObject.self,
        Cache.StorefrontsCache.self,
        Cache.SelectedStorefront.self,
        Cache.SongCache.self,
        Entity.Chart.ChartSongs.self,
        Entity.Search.Root.self,
        Entity.Search.Songs.self,
        Entity.Search.Albums.self,
        Entity.Search.Artists.self,
        Entity.StringValue.self,
        Entity.DeveloperToken.self,
        Entity.EditorialNotes.self,
        Entity.Artwork.self
    ]
    return objectTypes + [
        Entity.Storefront.classes,
        Entity.Genre.classes,
        Entity.Song.classes,
        Entity.MusicVideo.classes,
        Entity.Album.classes,
        Entity.Artist.classes
    ].flatten
}

public func StorefrontRealm() throws -> Realm {  // swiftlint:disable:this identifier_name
    var config = Realm.Configuration()
    config.deleteRealmIfMigrationNeeded = true
    config.objectTypes = objectTypes()
    let fileURL = config.fileURL?.deletingLastPathComponent()
    config.fileURL = fileURL?.appendingPathComponent("storefront.realm")
    return try Realm(configuration: config)
}

public func launch() {
    var config = Realm.Configuration.defaultConfiguration
    config.deleteRealmIfMigrationNeeded = true
    let objectTypes = [
        Cache.RequestObject.self,
        Cache.StorefrontsCache.self,
        Cache.SelectedStorefront.self,
        Cache.SongCache.self,
        Entity.Chart.ChartSongs.self,
        Entity.Search.Root.self,
        Entity.Search.Songs.self,
        Entity.Search.Albums.self,
        Entity.Search.Artists.self,
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
