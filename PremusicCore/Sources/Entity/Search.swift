//
//  Search.swift
//  PremusicCore
//
//  Created by 林達也 on 2017/09/06.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation
import RealmSwift

extension Entity {
    struct Search {}
}

extension Entity.Search {
    @objc(SearchRoot)
    final class Root: Entity.EntityObject {
        @objc private(set) dynamic var term: String = ""
        @objc private(set) dynamic var songs: Songs!
        @objc private(set) dynamic var albums: Albums!
        @objc private(set) dynamic var artists: Artists!

        override class func primaryKey() -> String? { return "term" }

        convenience required init(term: String) {
            self.init()
            self.term = term
            self.songs = Songs(term: term)
            self.albums = Albums(term: term)
            self.artists = Artists(term: term)
        }

        static func object(term: String, from realm: Realm) -> Root? {
            let cachedAt = Date(timeIntervalSinceNow: -0.5 * 60 * 60)
            return realm.objects(self).filter("term = %@ AND cachedAt > %@", term, cachedAt).first
        }
    }

    @objc(SearchSongs)
    final class Songs: Object, Collection {
        @objc private dynamic var term: String = ""
        private let songs = List<Entity.Song>()
        @objc private dynamic var next: Cache.RequestObject?

        override class func primaryKey() -> String? { return "term" }

        convenience init(term: String) {
            self.init()
            self.term = term
        }

        func request() -> SearchResources.GetPage<Entity.Song.Attributes>? {
            return next?.request()
        }

        func update(_ songs: [Entity.Song], next: SearchResources.GetPage<Entity.Song.Attributes>?, to realm: Realm) {
            self.songs.append(objectsIn: songs)
            if let next = next.flatMap({ Cache.RequestObject(key: "SearchSongs::\(term)", $0) }) {
                realm.add(next, update: true)
                self.next = next
            } else {
                self.next = nil
            }
        }

        // MARK: Collection
        public var startIndex: Int { return songs.startIndex }
        public var endIndex: Int { return songs.endIndex }
        public func index(after idx: Int) -> Int { return songs.index(after: idx) }
        public subscript(idx: Int) -> Entity.Song { return songs[idx] }
    }

    @objc(SearchAlbums)
    final class Albums: Object, Collection {
        @objc private dynamic var term: String = ""
        private let albums = List<Entity.Album>()
        @objc private dynamic var next: Cache.RequestObject?

        override class func primaryKey() -> String? { return "term" }

        convenience init(term: String) {
            self.init()
            self.term = term
        }

        func request() -> SearchResources.GetPage<Entity.Album.Attributes>? {
            return next?.request()
        }

        func update(_ albums: [Entity.Album], next: SearchResources.GetPage<Entity.Album.Attributes>?, to realm: Realm) {
            self.albums.append(objectsIn: albums)
            if let next = next.flatMap({ Cache.RequestObject(key: "SearchAlbums::\(term)", $0) }) {
                realm.add(next, update: true)
                self.next = next
            } else {
                self.next = nil
            }
        }

        // MARK: Collection
        public var startIndex: Int { return albums.startIndex }
        public var endIndex: Int { return albums.endIndex }
        public func index(after idx: Int) -> Int { return albums.index(after: idx) }
        public subscript(idx: Int) -> Entity.Album { return albums[idx] }
    }

    @objc(SearchArtists)
    final class Artists: Object, Collection {
        @objc private dynamic var term: String = ""
        private let artists = List<Entity.Artist>()
        @objc private dynamic var next: Cache.RequestObject?

        override class func primaryKey() -> String? { return "term" }

        convenience init(term: String) {
            self.init()
            self.term = term
        }

        func request() -> SearchResources.GetPage<Entity.Artist.Attributes>? {
            return next?.request()
        }

        func update(_ artists: [Entity.Artist], next: SearchResources.GetPage<Entity.Artist.Attributes>?, to realm: Realm) {
            self.artists.append(objectsIn: artists)
            if let next = next.flatMap({ Cache.RequestObject(key: "SearchArtists::\(term)", $0) }) {
                realm.add(next, update: true)
                self.next = next
            } else {
                self.next = nil
            }
        }

        // MARK: Collection
        public var startIndex: Int { return artists.startIndex }
        public var endIndex: Int { return artists.endIndex }
        public func index(after idx: Int) -> Int { return artists.index(after: idx) }
        public subscript(idx: Int) -> Entity.Artist { return artists[idx] }
    }
}
